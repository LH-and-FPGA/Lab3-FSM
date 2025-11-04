#include "Vf1_fsm.h"
#include "verilated.h"
#include "verilated_vcd_c.h"
#include "vbuddy.cpp"

int main(int argc, char **argv, char **env) {
    int i;
    int clk;

    Verilated::commandArgs(argc, argv);
    // TODO: Check the doc about this

    Vf1_fsm* f1_fsm = new Vf1_fsm;

    Verilated::traceEverOn(true);
    VerilatedVcdC* tfp = new VerilatedVcdC;
    f1_fsm->trace(tfp, 99);
    tfp->open("sinegen.vcd");

    // init vbuddy
    if (vbdOpen() != 1) return -1;
    vbdHeader("Lab 3: FSM");
    vbdSetMode(1);

    f1_fsm->clk = 0;
    f1_fsm->rst = 0;
    f1_fsm->en = 0;

    while(true) {
        // if (vbdFlag() == 1) {
        //     f1_fsm->en = !f1_fsm->en;
        // }
        f1_fsm->en = vbdFlag();

        vbdBar(f1_fsm->data_out & 0xFF);

        for (clk = 0; clk < 2; clk++) {
            // tfp->dump(2*i+clk);
            f1_fsm->clk = !f1_fsm->clk;
            f1_fsm->eval();
        }

        if (vbdGetkey() == 'q') {
            vbdClose();
            tfp->close();
            exit(0);
        }
    }

    vbdClose();
    tfp->close();
    exit(0);
}
