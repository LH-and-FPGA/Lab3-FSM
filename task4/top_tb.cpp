#include "Vtop.h"
#include "verilated.h"
#include "verilated_vcd_c.h"

#include "../vbuddy.cpp" // include vbuddy code
#define MAX_SIM_CYC 100000
#define top_N 46

enum class Record{
    INIT,
    PRE,
    READY,
    PUSH
};

int main(int argc, char **argv, char **env)
{
    int simcyc;     // simulation clock count
    int tick;       // each clk cycle has two ticks for two edges
    int lights = 0; // state to toggle LED lights

    Verilated::commandArgs(argc, argv);
    // init top verilog instance
    Vtop *top = new Vtop;
    // init trace dump
    Verilated::traceEverOn(true);
    VerilatedVcdC *tfp = new VerilatedVcdC;
    top->trace(tfp, 99);
    tfp->open("clktick.vcd");

    // init Vbuddy
    if (vbdOpen() != 1)
        return (-1);
    vbdHeader("L3T3");
    vbdSetMode(0); // Flag mode set to one-shot

    // initialize simulation inputs
    top->clk = 0;
    top->rst = 0;
    top->en = 1;
    top->N = top_N;
    Record record = Record::INIT;

    // run simulation for MAX_SIM_CYC clock cycles
    for (simcyc = 0; simcyc < MAX_SIM_CYC; simcyc++) {
        // dump variables into VCD file and toggle clock
        for (tick = 0; tick < 2; tick++) {
            tfp->dump(2 * simcyc + tick);
            top->clk = !top->clk;
            top->eval();
        }

        top->rst = (simcyc < 2); // assert reset for 1st cycle
        top->trigger = vbdFlag();
        vbdBar(top->data_out & 0xFF);
        vbdCycle(simcyc);

        switch (record)
        {
        case Record::INIT:
            if (top->data_out == 0b11111111) record = Record::PRE;
            break;
        case Record::PRE:
            if (top->data_out != 0b11111111) record = Record::READY;
            break;
        case Record::READY:
            vbdInitWatch();
            record = Record::PUSH;
            break;
        case Record::PUSH:
            if (!vbdFlag()) {
                int result = vbdElapsed();
                vbdHex(4, (int(result) >> 16) & 0xF);
                vbdHex(3, (int(result) >> 8) & 0xF);
                vbdHex(2, (int(result) >> 4) & 0xF);
                vbdHex(1, (int(result)) & 0xF);
            }
        default:
            break;
        }
        
        if (vbdGetkey() == 'q') {
            vbdClose();
            tfp->close();
            exit(0);
        }
    }

    vbdClose(); // ++++
    tfp->close();
    exit(0);
}
