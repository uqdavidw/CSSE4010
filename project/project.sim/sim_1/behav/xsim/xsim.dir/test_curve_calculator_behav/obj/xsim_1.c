/**********************************************************************/
/*   ____  ____                                                       */
/*  /   /\/   /                                                       */
/* /___/  \  /                                                        */
/* \   \   \/                                                         */
/*  \   \        Copyright (c) 2003-2013 Xilinx, Inc.                 */
/*  /   /        All Right Reserved.                                  */
/* /---/   /\                                                         */
/* \   \  /  \                                                        */
/*  \___\/\___\                                                       */
/**********************************************************************/


#include "iki.h"
#include <string.h>
#include <math.h>
#ifdef __GNUC__
#include <stdlib.h>
#else
#include <malloc.h>
#define alloca _alloca
#endif
/**********************************************************************/
/*   ____  ____                                                       */
/*  /   /\/   /                                                       */
/* /___/  \  /                                                        */
/* \   \   \/                                                         */
/*  \   \        Copyright (c) 2003-2013 Xilinx, Inc.                 */
/*  /   /        All Right Reserved.                                  */
/* /---/   /\                                                         */
/* \   \  /  \                                                        */
/*  \___\/\___\                                                       */
/**********************************************************************/


#include "iki.h"
#include <string.h>
#include <math.h>
#ifdef __GNUC__
#include <stdlib.h>
#else
#include <malloc.h>
#define alloca _alloca
#endif
typedef void (*funcp)(char *, char *);
extern int main(int, char**);
extern void execute_15(char*, char *);
extern void execute_16(char*, char *);
extern void execute_17(char*, char *);
extern void execute_18(char*, char *);
extern void execute_20(char*, char *);
extern void execute_22(char*, char *);
extern void execute_23(char*, char *);
extern void execute_5665(char*, char *);
extern void execute_190(char*, char *);
extern void execute_192(char*, char *);
extern void execute_235(char*, char *);
extern void execute_162(char*, char *);
extern void execute_165(char*, char *);
extern void execute_168(char*, char *);
extern void execute_171(char*, char *);
extern void execute_174(char*, char *);
extern void execute_176(char*, char *);
extern void execute_179(char*, char *);
extern void execute_180(char*, char *);
extern void execute_181(char*, char *);
extern void execute_182(char*, char *);
extern void execute_183(char*, char *);
extern void execute_184(char*, char *);
extern void execute_185(char*, char *);
extern void execute_186(char*, char *);
extern void execute_187(char*, char *);
extern void execute_188(char*, char *);
extern void execute_5649(char*, char *);
extern void execute_5654(char*, char *);
extern void execute_5655(char*, char *);
extern void execute_5656(char*, char *);
extern void execute_5659(char*, char *);
extern void execute_5660(char*, char *);
extern void execute_5663(char*, char *);
extern void execute_209(char*, char *);
extern void execute_210(char*, char *);
extern void execute_234(char*, char *);
extern void execute_200(char*, char *);
extern void execute_206(char*, char *);
extern void execute_207(char*, char *);
extern void execute_204(char*, char *);
extern void execute_212(char*, char *);
extern void execute_214(char*, char *);
extern void execute_216(char*, char *);
extern void execute_218(char*, char *);
extern void execute_220(char*, char *);
extern void execute_222(char*, char *);
extern void execute_224(char*, char *);
extern void execute_226(char*, char *);
extern void execute_228(char*, char *);
extern void execute_230(char*, char *);
extern void execute_232(char*, char *);
extern void execute_238(char*, char *);
extern void execute_239(char*, char *);
extern void execute_240(char*, char *);
extern void execute_241(char*, char *);
extern void execute_242(char*, char *);
extern void execute_243(char*, char *);
extern void execute_244(char*, char *);
extern void execute_246(char*, char *);
extern void execute_247(char*, char *);
extern void execute_248(char*, char *);
extern void execute_252(char*, char *);
extern void execute_253(char*, char *);
extern void execute_254(char*, char *);
extern void execute_5634(char*, char *);
extern void execute_5637(char*, char *);
extern void execute_5641(char*, char *);
extern void execute_5644(char*, char *);
extern void execute_5647(char*, char *);
extern void execute_1142(char*, char *);
extern void execute_1143(char*, char *);
extern void execute_1144(char*, char *);
extern void execute_1148(char*, char *);
extern void execute_261(char*, char *);
extern void execute_265(char*, char *);
extern void execute_266(char*, char *);
extern void execute_267(char*, char *);
extern void execute_268(char*, char *);
extern void execute_272(char*, char *);
extern void execute_273(char*, char *);
extern void execute_1108(char*, char *);
extern void execute_1109(char*, char *);
extern void execute_1110(char*, char *);
extern void execute_1111(char*, char *);
extern void execute_1112(char*, char *);
extern void execute_1113(char*, char *);
extern void execute_1114(char*, char *);
extern void execute_1124(char*, char *);
extern void execute_1125(char*, char *);
extern void execute_1146(char*, char *);
extern void execute_1147(char*, char *);
extern void execute_491(char*, char *);
extern void execute_483(char*, char *);
extern void execute_486(char*, char *);
extern void execute_294(char*, char *);
extern void execute_296(char*, char *);
extern void execute_298(char*, char *);
extern void execute_300(char*, char *);
extern void execute_304(char*, char *);
extern void execute_307(char*, char *);
extern void execute_312(char*, char *);
extern void execute_314(char*, char *);
extern void execute_316(char*, char *);
extern void execute_318(char*, char *);
extern void execute_479(char*, char *);
extern void execute_480(char*, char *);
extern void execute_333(char*, char *);
extern void execute_337(char*, char *);
extern void execute_336(char*, char *);
extern void execute_341(char*, char *);
extern void execute_344(char*, char *);
extern void execute_347(char*, char *);
extern void execute_350(char*, char *);
extern void execute_353(char*, char *);
extern void execute_356(char*, char *);
extern void execute_358(char*, char *);
extern void execute_359(char*, char *);
extern void execute_360(char*, char *);
extern void execute_365(char*, char *);
extern void execute_368(char*, char *);
extern void execute_370(char*, char *);
extern void execute_374(char*, char *);
extern void execute_376(char*, char *);
extern void execute_380(char*, char *);
extern void execute_413(char*, char *);
extern void execute_414(char*, char *);
extern void execute_417(char*, char *);
extern void execute_408(char*, char *);
extern void execute_389(char*, char *);
extern void execute_392(char*, char *);
extern void execute_395(char*, char *);
extern void execute_398(char*, char *);
extern void execute_401(char*, char *);
extern void execute_407(char*, char *);
extern void execute_403(char*, char *);
extern void execute_404(char*, char *);
extern void execute_405(char*, char *);
extern void execute_419(char*, char *);
extern void execute_421(char*, char *);
extern void execute_1106(char*, char *);
extern void execute_1107(char*, char *);
extern void execute_1131(char*, char *);
extern void execute_1132(char*, char *);
extern void execute_1138(char*, char *);
extern void execute_1139(char*, char *);
extern void execute_1150(char*, char *);
extern void execute_1151(char*, char *);
extern void execute_1152(char*, char *);
extern void execute_1153(char*, char *);
extern void execute_1154(char*, char *);
extern void execute_1155(char*, char *);
extern void execute_1156(char*, char *);
extern void execute_5043(char*, char *);
extern void execute_5044(char*, char *);
extern void execute_5045(char*, char *);
extern void execute_5046(char*, char *);
extern void execute_5047(char*, char *);
extern void execute_5041(char*, char *);
extern void execute_1801(char*, char *);
extern void execute_1802(char*, char *);
extern void execute_1803(char*, char *);
extern void execute_1804(char*, char *);
extern void execute_1162(char*, char *);
extern void execute_1163(char*, char *);
extern void execute_1164(char*, char *);
extern void execute_1165(char*, char *);
extern void execute_1369(char*, char *);
extern void execute_1573(char*, char *);
extern void execute_1574(char*, char *);
extern void execute_1575(char*, char *);
extern void execute_1576(char*, char *);
extern void execute_1577(char*, char *);
extern void execute_1782(char*, char *);
extern void execute_1783(char*, char *);
extern void execute_1784(char*, char *);
extern void execute_1785(char*, char *);
extern void execute_1792(char*, char *);
extern void execute_1793(char*, char *);
extern void execute_1799(char*, char *);
extern void execute_1800(char*, char *);
extern void execute_2448(char*, char *);
extern void execute_2449(char*, char *);
extern void execute_2450(char*, char *);
extern void execute_2451(char*, char *);
extern void execute_1809(char*, char *);
extern void execute_1810(char*, char *);
extern void execute_1811(char*, char *);
extern void execute_1812(char*, char *);
extern void execute_2016(char*, char *);
extern void execute_2220(char*, char *);
extern void execute_2221(char*, char *);
extern void execute_2222(char*, char *);
extern void execute_2223(char*, char *);
extern void execute_2224(char*, char *);
extern void execute_3095(char*, char *);
extern void execute_3096(char*, char *);
extern void execute_3097(char*, char *);
extern void execute_3098(char*, char *);
extern void execute_2456(char*, char *);
extern void execute_2457(char*, char *);
extern void execute_2458(char*, char *);
extern void execute_2459(char*, char *);
extern void execute_2663(char*, char *);
extern void execute_2867(char*, char *);
extern void execute_2868(char*, char *);
extern void execute_2869(char*, char *);
extern void execute_2870(char*, char *);
extern void execute_2871(char*, char *);
extern void execute_3742(char*, char *);
extern void execute_3743(char*, char *);
extern void execute_3744(char*, char *);
extern void execute_3745(char*, char *);
extern void execute_3103(char*, char *);
extern void execute_3104(char*, char *);
extern void execute_3105(char*, char *);
extern void execute_3106(char*, char *);
extern void execute_3310(char*, char *);
extern void execute_3514(char*, char *);
extern void execute_3515(char*, char *);
extern void execute_3516(char*, char *);
extern void execute_3517(char*, char *);
extern void execute_3518(char*, char *);
extern void execute_4389(char*, char *);
extern void execute_4390(char*, char *);
extern void execute_4391(char*, char *);
extern void execute_4392(char*, char *);
extern void execute_3750(char*, char *);
extern void execute_3751(char*, char *);
extern void execute_3752(char*, char *);
extern void execute_3753(char*, char *);
extern void execute_3957(char*, char *);
extern void execute_4161(char*, char *);
extern void execute_4162(char*, char *);
extern void execute_4163(char*, char *);
extern void execute_4164(char*, char *);
extern void execute_4165(char*, char *);
extern void execute_5036(char*, char *);
extern void execute_5037(char*, char *);
extern void execute_5038(char*, char *);
extern void execute_5039(char*, char *);
extern void execute_4397(char*, char *);
extern void execute_4398(char*, char *);
extern void execute_4399(char*, char *);
extern void execute_4400(char*, char *);
extern void execute_4604(char*, char *);
extern void execute_4808(char*, char *);
extern void execute_4809(char*, char *);
extern void execute_4810(char*, char *);
extern void execute_4811(char*, char *);
extern void execute_4812(char*, char *);
extern void execute_5049(char*, char *);
extern void execute_5050(char*, char *);
extern void execute_5057(char*, char *);
extern void execute_5519(char*, char *);
extern void execute_5628(char*, char *);
extern void execute_5629(char*, char *);
extern void execute_5630(char*, char *);
extern void execute_5631(char*, char *);
extern void execute_5060(char*, char *);
extern void execute_5061(char*, char *);
extern void execute_5062(char*, char *);
extern void execute_5063(char*, char *);
extern void execute_5471(char*, char *);
extern void execute_5479(char*, char *);
extern void execute_5487(char*, char *);
extern void execute_5517(char*, char *);
extern void execute_5513(char*, char *);
extern void execute_5515(char*, char *);
extern void execute_5498(char*, char *);
extern void execute_5522(char*, char *);
extern void execute_5523(char*, char *);
extern void execute_5527(char*, char *);
extern void execute_5531(char*, char *);
extern void execute_5535(char*, char *);
extern void execute_5539(char*, char *);
extern void execute_5543(char*, char *);
extern void execute_5547(char*, char *);
extern void execute_5551(char*, char *);
extern void execute_5555(char*, char *);
extern void execute_5563(char*, char *);
extern void execute_5564(char*, char *);
extern void execute_5054(char*, char *);
extern void transaction_0(char*, char*, unsigned, unsigned, unsigned);
extern void vhdl_transfunc_eventcallback(char*, char*, unsigned, unsigned, unsigned, char *);
extern void transaction_76(char*, char*, unsigned, unsigned, unsigned);
extern void transaction_77(char*, char*, unsigned, unsigned, unsigned);
funcp funcTab[287] = {(funcp)execute_15, (funcp)execute_16, (funcp)execute_17, (funcp)execute_18, (funcp)execute_20, (funcp)execute_22, (funcp)execute_23, (funcp)execute_5665, (funcp)execute_190, (funcp)execute_192, (funcp)execute_235, (funcp)execute_162, (funcp)execute_165, (funcp)execute_168, (funcp)execute_171, (funcp)execute_174, (funcp)execute_176, (funcp)execute_179, (funcp)execute_180, (funcp)execute_181, (funcp)execute_182, (funcp)execute_183, (funcp)execute_184, (funcp)execute_185, (funcp)execute_186, (funcp)execute_187, (funcp)execute_188, (funcp)execute_5649, (funcp)execute_5654, (funcp)execute_5655, (funcp)execute_5656, (funcp)execute_5659, (funcp)execute_5660, (funcp)execute_5663, (funcp)execute_209, (funcp)execute_210, (funcp)execute_234, (funcp)execute_200, (funcp)execute_206, (funcp)execute_207, (funcp)execute_204, (funcp)execute_212, (funcp)execute_214, (funcp)execute_216, (funcp)execute_218, (funcp)execute_220, (funcp)execute_222, (funcp)execute_224, (funcp)execute_226, (funcp)execute_228, (funcp)execute_230, (funcp)execute_232, (funcp)execute_238, (funcp)execute_239, (funcp)execute_240, (funcp)execute_241, (funcp)execute_242, (funcp)execute_243, (funcp)execute_244, (funcp)execute_246, (funcp)execute_247, (funcp)execute_248, (funcp)execute_252, (funcp)execute_253, (funcp)execute_254, (funcp)execute_5634, (funcp)execute_5637, (funcp)execute_5641, (funcp)execute_5644, (funcp)execute_5647, (funcp)execute_1142, (funcp)execute_1143, (funcp)execute_1144, (funcp)execute_1148, (funcp)execute_261, (funcp)execute_265, (funcp)execute_266, (funcp)execute_267, (funcp)execute_268, (funcp)execute_272, (funcp)execute_273, (funcp)execute_1108, (funcp)execute_1109, (funcp)execute_1110, (funcp)execute_1111, (funcp)execute_1112, (funcp)execute_1113, (funcp)execute_1114, (funcp)execute_1124, (funcp)execute_1125, (funcp)execute_1146, (funcp)execute_1147, (funcp)execute_491, (funcp)execute_483, (funcp)execute_486, (funcp)execute_294, (funcp)execute_296, (funcp)execute_298, (funcp)execute_300, (funcp)execute_304, (funcp)execute_307, (funcp)execute_312, (funcp)execute_314, (funcp)execute_316, (funcp)execute_318, (funcp)execute_479, (funcp)execute_480, (funcp)execute_333, (funcp)execute_337, (funcp)execute_336, (funcp)execute_341, (funcp)execute_344, (funcp)execute_347, (funcp)execute_350, (funcp)execute_353, (funcp)execute_356, (funcp)execute_358, (funcp)execute_359, (funcp)execute_360, (funcp)execute_365, (funcp)execute_368, (funcp)execute_370, (funcp)execute_374, (funcp)execute_376, (funcp)execute_380, (funcp)execute_413, (funcp)execute_414, (funcp)execute_417, (funcp)execute_408, (funcp)execute_389, (funcp)execute_392, (funcp)execute_395, (funcp)execute_398, (funcp)execute_401, (funcp)execute_407, (funcp)execute_403, (funcp)execute_404, (funcp)execute_405, (funcp)execute_419, (funcp)execute_421, (funcp)execute_1106, (funcp)execute_1107, (funcp)execute_1131, (funcp)execute_1132, (funcp)execute_1138, (funcp)execute_1139, (funcp)execute_1150, (funcp)execute_1151, (funcp)execute_1152, (funcp)execute_1153, (funcp)execute_1154, (funcp)execute_1155, (funcp)execute_1156, (funcp)execute_5043, (funcp)execute_5044, (funcp)execute_5045, (funcp)execute_5046, (funcp)execute_5047, (funcp)execute_5041, (funcp)execute_1801, (funcp)execute_1802, (funcp)execute_1803, (funcp)execute_1804, (funcp)execute_1162, (funcp)execute_1163, (funcp)execute_1164, (funcp)execute_1165, (funcp)execute_1369, (funcp)execute_1573, (funcp)execute_1574, (funcp)execute_1575, (funcp)execute_1576, (funcp)execute_1577, (funcp)execute_1782, (funcp)execute_1783, (funcp)execute_1784, (funcp)execute_1785, (funcp)execute_1792, (funcp)execute_1793, (funcp)execute_1799, (funcp)execute_1800, (funcp)execute_2448, (funcp)execute_2449, (funcp)execute_2450, (funcp)execute_2451, (funcp)execute_1809, (funcp)execute_1810, (funcp)execute_1811, (funcp)execute_1812, (funcp)execute_2016, (funcp)execute_2220, (funcp)execute_2221, (funcp)execute_2222, (funcp)execute_2223, (funcp)execute_2224, (funcp)execute_3095, (funcp)execute_3096, (funcp)execute_3097, (funcp)execute_3098, (funcp)execute_2456, (funcp)execute_2457, (funcp)execute_2458, (funcp)execute_2459, (funcp)execute_2663, (funcp)execute_2867, (funcp)execute_2868, (funcp)execute_2869, (funcp)execute_2870, (funcp)execute_2871, (funcp)execute_3742, (funcp)execute_3743, (funcp)execute_3744, (funcp)execute_3745, (funcp)execute_3103, (funcp)execute_3104, (funcp)execute_3105, (funcp)execute_3106, (funcp)execute_3310, (funcp)execute_3514, (funcp)execute_3515, (funcp)execute_3516, (funcp)execute_3517, (funcp)execute_3518, (funcp)execute_4389, (funcp)execute_4390, (funcp)execute_4391, (funcp)execute_4392, (funcp)execute_3750, (funcp)execute_3751, (funcp)execute_3752, (funcp)execute_3753, (funcp)execute_3957, (funcp)execute_4161, (funcp)execute_4162, (funcp)execute_4163, (funcp)execute_4164, (funcp)execute_4165, (funcp)execute_5036, (funcp)execute_5037, (funcp)execute_5038, (funcp)execute_5039, (funcp)execute_4397, (funcp)execute_4398, (funcp)execute_4399, (funcp)execute_4400, (funcp)execute_4604, (funcp)execute_4808, (funcp)execute_4809, (funcp)execute_4810, (funcp)execute_4811, (funcp)execute_4812, (funcp)execute_5049, (funcp)execute_5050, (funcp)execute_5057, (funcp)execute_5519, (funcp)execute_5628, (funcp)execute_5629, (funcp)execute_5630, (funcp)execute_5631, (funcp)execute_5060, (funcp)execute_5061, (funcp)execute_5062, (funcp)execute_5063, (funcp)execute_5471, (funcp)execute_5479, (funcp)execute_5487, (funcp)execute_5517, (funcp)execute_5513, (funcp)execute_5515, (funcp)execute_5498, (funcp)execute_5522, (funcp)execute_5523, (funcp)execute_5527, (funcp)execute_5531, (funcp)execute_5535, (funcp)execute_5539, (funcp)execute_5543, (funcp)execute_5547, (funcp)execute_5551, (funcp)execute_5555, (funcp)execute_5563, (funcp)execute_5564, (funcp)execute_5054, (funcp)transaction_0, (funcp)vhdl_transfunc_eventcallback, (funcp)transaction_76, (funcp)transaction_77};
const int NumRelocateId= 287;

void relocate(char *dp)
{
	iki_relocate(dp, "xsim.dir/test_curve_calculator_behav/xsim.reloc",  (void **)funcTab, 287);
	iki_vhdl_file_variable_register(dp + 546344);
	iki_vhdl_file_variable_register(dp + 546400);


	/*Populate the transaction function pointer field in the whole net structure */
}

void sensitize(char *dp)
{
	iki_sensitize(dp, "xsim.dir/test_curve_calculator_behav/xsim.reloc");
}

void simulate(char *dp)
{
	iki_schedule_processes_at_time_zero(dp, "xsim.dir/test_curve_calculator_behav/xsim.reloc");
	// Initialize Verilog nets in mixed simulation, for the cases when the value at time 0 should be propagated from the mixed language Vhdl net
	iki_execute_processes();

	// Schedule resolution functions for the multiply driven Verilog nets that have strength
	// Schedule transaction functions for the singly driven Verilog nets that have strength

}
#include "iki_bridge.h"
void relocate(char *);

void sensitize(char *);

void simulate(char *);

extern SYSTEMCLIB_IMP_DLLSPEC void local_register_implicit_channel(int, char*);
extern void implicit_HDL_SCinstatiate();

extern int xsim_argc_copy ;
extern char** xsim_argv_copy ;

int main(int argc, char **argv)
{
    iki_heap_initialize("ms", "isimmm", 0, 2147483648) ;
    iki_set_sv_type_file_path_name("xsim.dir/test_curve_calculator_behav/xsim.svtype");
    iki_set_crvs_dump_file_path_name("xsim.dir/test_curve_calculator_behav/xsim.crvsdump");
    void* design_handle = iki_create_design("xsim.dir/test_curve_calculator_behav/xsim.mem", (void *)relocate, (void *)sensitize, (void *)simulate, 0, isimBridge_getWdbWriter(), 0, argc, argv);
     iki_set_rc_trial_count(100);
    (void) design_handle;
    return iki_simulate_design();
}
