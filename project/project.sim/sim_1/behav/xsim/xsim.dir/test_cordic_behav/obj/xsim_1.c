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
extern void execute_30(char*, char *);
extern void execute_31(char*, char *);
extern void execute_32(char*, char *);
extern void execute_5649(char*, char *);
extern void execute_174(char*, char *);
extern void execute_176(char*, char *);
extern void execute_219(char*, char *);
extern void execute_146(char*, char *);
extern void execute_149(char*, char *);
extern void execute_152(char*, char *);
extern void execute_155(char*, char *);
extern void execute_158(char*, char *);
extern void execute_160(char*, char *);
extern void execute_163(char*, char *);
extern void execute_164(char*, char *);
extern void execute_165(char*, char *);
extern void execute_166(char*, char *);
extern void execute_167(char*, char *);
extern void execute_168(char*, char *);
extern void execute_169(char*, char *);
extern void execute_170(char*, char *);
extern void execute_171(char*, char *);
extern void execute_172(char*, char *);
extern void execute_5633(char*, char *);
extern void execute_5638(char*, char *);
extern void execute_5639(char*, char *);
extern void execute_5640(char*, char *);
extern void execute_5643(char*, char *);
extern void execute_5644(char*, char *);
extern void execute_5647(char*, char *);
extern void execute_193(char*, char *);
extern void execute_194(char*, char *);
extern void execute_218(char*, char *);
extern void execute_184(char*, char *);
extern void execute_190(char*, char *);
extern void execute_191(char*, char *);
extern void execute_188(char*, char *);
extern void execute_196(char*, char *);
extern void execute_198(char*, char *);
extern void execute_200(char*, char *);
extern void execute_202(char*, char *);
extern void execute_204(char*, char *);
extern void execute_206(char*, char *);
extern void execute_208(char*, char *);
extern void execute_210(char*, char *);
extern void execute_212(char*, char *);
extern void execute_214(char*, char *);
extern void execute_216(char*, char *);
extern void execute_222(char*, char *);
extern void execute_223(char*, char *);
extern void execute_224(char*, char *);
extern void execute_225(char*, char *);
extern void execute_226(char*, char *);
extern void execute_227(char*, char *);
extern void execute_228(char*, char *);
extern void execute_230(char*, char *);
extern void execute_231(char*, char *);
extern void execute_232(char*, char *);
extern void execute_236(char*, char *);
extern void execute_237(char*, char *);
extern void execute_238(char*, char *);
extern void execute_5618(char*, char *);
extern void execute_5621(char*, char *);
extern void execute_5625(char*, char *);
extern void execute_5628(char*, char *);
extern void execute_5631(char*, char *);
extern void execute_1126(char*, char *);
extern void execute_1127(char*, char *);
extern void execute_1128(char*, char *);
extern void execute_1132(char*, char *);
extern void execute_245(char*, char *);
extern void execute_249(char*, char *);
extern void execute_250(char*, char *);
extern void execute_251(char*, char *);
extern void execute_252(char*, char *);
extern void execute_256(char*, char *);
extern void execute_257(char*, char *);
extern void execute_1092(char*, char *);
extern void execute_1093(char*, char *);
extern void execute_1094(char*, char *);
extern void execute_1095(char*, char *);
extern void execute_1096(char*, char *);
extern void execute_1097(char*, char *);
extern void execute_1098(char*, char *);
extern void execute_1108(char*, char *);
extern void execute_1109(char*, char *);
extern void execute_1130(char*, char *);
extern void execute_1131(char*, char *);
extern void execute_475(char*, char *);
extern void execute_467(char*, char *);
extern void execute_470(char*, char *);
extern void execute_278(char*, char *);
extern void execute_280(char*, char *);
extern void execute_282(char*, char *);
extern void execute_284(char*, char *);
extern void execute_288(char*, char *);
extern void execute_291(char*, char *);
extern void execute_296(char*, char *);
extern void execute_298(char*, char *);
extern void execute_300(char*, char *);
extern void execute_302(char*, char *);
extern void execute_463(char*, char *);
extern void execute_464(char*, char *);
extern void execute_317(char*, char *);
extern void execute_321(char*, char *);
extern void execute_320(char*, char *);
extern void execute_325(char*, char *);
extern void execute_328(char*, char *);
extern void execute_331(char*, char *);
extern void execute_334(char*, char *);
extern void execute_337(char*, char *);
extern void execute_340(char*, char *);
extern void execute_342(char*, char *);
extern void execute_343(char*, char *);
extern void execute_344(char*, char *);
extern void execute_349(char*, char *);
extern void execute_352(char*, char *);
extern void execute_354(char*, char *);
extern void execute_358(char*, char *);
extern void execute_360(char*, char *);
extern void execute_364(char*, char *);
extern void execute_397(char*, char *);
extern void execute_398(char*, char *);
extern void execute_401(char*, char *);
extern void execute_392(char*, char *);
extern void execute_373(char*, char *);
extern void execute_376(char*, char *);
extern void execute_379(char*, char *);
extern void execute_382(char*, char *);
extern void execute_385(char*, char *);
extern void execute_391(char*, char *);
extern void execute_387(char*, char *);
extern void execute_388(char*, char *);
extern void execute_389(char*, char *);
extern void execute_403(char*, char *);
extern void execute_405(char*, char *);
extern void execute_1090(char*, char *);
extern void execute_1091(char*, char *);
extern void execute_1115(char*, char *);
extern void execute_1116(char*, char *);
extern void execute_1122(char*, char *);
extern void execute_1123(char*, char *);
extern void execute_1134(char*, char *);
extern void execute_1135(char*, char *);
extern void execute_1136(char*, char *);
extern void execute_1137(char*, char *);
extern void execute_1138(char*, char *);
extern void execute_1139(char*, char *);
extern void execute_1140(char*, char *);
extern void execute_5027(char*, char *);
extern void execute_5028(char*, char *);
extern void execute_5029(char*, char *);
extern void execute_5030(char*, char *);
extern void execute_5031(char*, char *);
extern void execute_5025(char*, char *);
extern void execute_1785(char*, char *);
extern void execute_1786(char*, char *);
extern void execute_1787(char*, char *);
extern void execute_1788(char*, char *);
extern void execute_1146(char*, char *);
extern void execute_1147(char*, char *);
extern void execute_1148(char*, char *);
extern void execute_1149(char*, char *);
extern void execute_1353(char*, char *);
extern void execute_1557(char*, char *);
extern void execute_1558(char*, char *);
extern void execute_1559(char*, char *);
extern void execute_1560(char*, char *);
extern void execute_1561(char*, char *);
extern void execute_1766(char*, char *);
extern void execute_1767(char*, char *);
extern void execute_1768(char*, char *);
extern void execute_1769(char*, char *);
extern void execute_1776(char*, char *);
extern void execute_1777(char*, char *);
extern void execute_1783(char*, char *);
extern void execute_1784(char*, char *);
extern void execute_2432(char*, char *);
extern void execute_2433(char*, char *);
extern void execute_2434(char*, char *);
extern void execute_2435(char*, char *);
extern void execute_1793(char*, char *);
extern void execute_1794(char*, char *);
extern void execute_1795(char*, char *);
extern void execute_1796(char*, char *);
extern void execute_2000(char*, char *);
extern void execute_2204(char*, char *);
extern void execute_2205(char*, char *);
extern void execute_2206(char*, char *);
extern void execute_2207(char*, char *);
extern void execute_2208(char*, char *);
extern void execute_3079(char*, char *);
extern void execute_3080(char*, char *);
extern void execute_3081(char*, char *);
extern void execute_3082(char*, char *);
extern void execute_2440(char*, char *);
extern void execute_2441(char*, char *);
extern void execute_2442(char*, char *);
extern void execute_2443(char*, char *);
extern void execute_2647(char*, char *);
extern void execute_2851(char*, char *);
extern void execute_2852(char*, char *);
extern void execute_2853(char*, char *);
extern void execute_2854(char*, char *);
extern void execute_2855(char*, char *);
extern void execute_3726(char*, char *);
extern void execute_3727(char*, char *);
extern void execute_3728(char*, char *);
extern void execute_3729(char*, char *);
extern void execute_3087(char*, char *);
extern void execute_3088(char*, char *);
extern void execute_3089(char*, char *);
extern void execute_3090(char*, char *);
extern void execute_3294(char*, char *);
extern void execute_3498(char*, char *);
extern void execute_3499(char*, char *);
extern void execute_3500(char*, char *);
extern void execute_3501(char*, char *);
extern void execute_3502(char*, char *);
extern void execute_4373(char*, char *);
extern void execute_4374(char*, char *);
extern void execute_4375(char*, char *);
extern void execute_4376(char*, char *);
extern void execute_3734(char*, char *);
extern void execute_3735(char*, char *);
extern void execute_3736(char*, char *);
extern void execute_3737(char*, char *);
extern void execute_3941(char*, char *);
extern void execute_4145(char*, char *);
extern void execute_4146(char*, char *);
extern void execute_4147(char*, char *);
extern void execute_4148(char*, char *);
extern void execute_4149(char*, char *);
extern void execute_5020(char*, char *);
extern void execute_5021(char*, char *);
extern void execute_5022(char*, char *);
extern void execute_5023(char*, char *);
extern void execute_4381(char*, char *);
extern void execute_4382(char*, char *);
extern void execute_4383(char*, char *);
extern void execute_4384(char*, char *);
extern void execute_4588(char*, char *);
extern void execute_4792(char*, char *);
extern void execute_4793(char*, char *);
extern void execute_4794(char*, char *);
extern void execute_4795(char*, char *);
extern void execute_4796(char*, char *);
extern void execute_5033(char*, char *);
extern void execute_5034(char*, char *);
extern void execute_5041(char*, char *);
extern void execute_5503(char*, char *);
extern void execute_5612(char*, char *);
extern void execute_5613(char*, char *);
extern void execute_5614(char*, char *);
extern void execute_5615(char*, char *);
extern void execute_5044(char*, char *);
extern void execute_5045(char*, char *);
extern void execute_5046(char*, char *);
extern void execute_5047(char*, char *);
extern void execute_5455(char*, char *);
extern void execute_5463(char*, char *);
extern void execute_5471(char*, char *);
extern void execute_5501(char*, char *);
extern void execute_5497(char*, char *);
extern void execute_5499(char*, char *);
extern void execute_5482(char*, char *);
extern void execute_5506(char*, char *);
extern void execute_5507(char*, char *);
extern void execute_5511(char*, char *);
extern void execute_5515(char*, char *);
extern void execute_5519(char*, char *);
extern void execute_5523(char*, char *);
extern void execute_5527(char*, char *);
extern void execute_5531(char*, char *);
extern void execute_5535(char*, char *);
extern void execute_5539(char*, char *);
extern void execute_5547(char*, char *);
extern void execute_5548(char*, char *);
extern void execute_5038(char*, char *);
extern void transaction_0(char*, char*, unsigned, unsigned, unsigned);
extern void transaction_3(char*, char*, unsigned, unsigned, unsigned);
extern void transaction_4(char*, char*, unsigned, unsigned, unsigned);
extern void transaction_5(char*, char*, unsigned, unsigned, unsigned);
extern void transaction_6(char*, char*, unsigned, unsigned, unsigned);
extern void transaction_7(char*, char*, unsigned, unsigned, unsigned);
extern void vhdl_transfunc_eventcallback(char*, char*, unsigned, unsigned, unsigned, char *);
extern void transaction_35(char*, char*, unsigned, unsigned, unsigned);
extern void transaction_36(char*, char*, unsigned, unsigned, unsigned);
funcp funcTab[288] = {(funcp)execute_30, (funcp)execute_31, (funcp)execute_32, (funcp)execute_5649, (funcp)execute_174, (funcp)execute_176, (funcp)execute_219, (funcp)execute_146, (funcp)execute_149, (funcp)execute_152, (funcp)execute_155, (funcp)execute_158, (funcp)execute_160, (funcp)execute_163, (funcp)execute_164, (funcp)execute_165, (funcp)execute_166, (funcp)execute_167, (funcp)execute_168, (funcp)execute_169, (funcp)execute_170, (funcp)execute_171, (funcp)execute_172, (funcp)execute_5633, (funcp)execute_5638, (funcp)execute_5639, (funcp)execute_5640, (funcp)execute_5643, (funcp)execute_5644, (funcp)execute_5647, (funcp)execute_193, (funcp)execute_194, (funcp)execute_218, (funcp)execute_184, (funcp)execute_190, (funcp)execute_191, (funcp)execute_188, (funcp)execute_196, (funcp)execute_198, (funcp)execute_200, (funcp)execute_202, (funcp)execute_204, (funcp)execute_206, (funcp)execute_208, (funcp)execute_210, (funcp)execute_212, (funcp)execute_214, (funcp)execute_216, (funcp)execute_222, (funcp)execute_223, (funcp)execute_224, (funcp)execute_225, (funcp)execute_226, (funcp)execute_227, (funcp)execute_228, (funcp)execute_230, (funcp)execute_231, (funcp)execute_232, (funcp)execute_236, (funcp)execute_237, (funcp)execute_238, (funcp)execute_5618, (funcp)execute_5621, (funcp)execute_5625, (funcp)execute_5628, (funcp)execute_5631, (funcp)execute_1126, (funcp)execute_1127, (funcp)execute_1128, (funcp)execute_1132, (funcp)execute_245, (funcp)execute_249, (funcp)execute_250, (funcp)execute_251, (funcp)execute_252, (funcp)execute_256, (funcp)execute_257, (funcp)execute_1092, (funcp)execute_1093, (funcp)execute_1094, (funcp)execute_1095, (funcp)execute_1096, (funcp)execute_1097, (funcp)execute_1098, (funcp)execute_1108, (funcp)execute_1109, (funcp)execute_1130, (funcp)execute_1131, (funcp)execute_475, (funcp)execute_467, (funcp)execute_470, (funcp)execute_278, (funcp)execute_280, (funcp)execute_282, (funcp)execute_284, (funcp)execute_288, (funcp)execute_291, (funcp)execute_296, (funcp)execute_298, (funcp)execute_300, (funcp)execute_302, (funcp)execute_463, (funcp)execute_464, (funcp)execute_317, (funcp)execute_321, (funcp)execute_320, (funcp)execute_325, (funcp)execute_328, (funcp)execute_331, (funcp)execute_334, (funcp)execute_337, (funcp)execute_340, (funcp)execute_342, (funcp)execute_343, (funcp)execute_344, (funcp)execute_349, (funcp)execute_352, (funcp)execute_354, (funcp)execute_358, (funcp)execute_360, (funcp)execute_364, (funcp)execute_397, (funcp)execute_398, (funcp)execute_401, (funcp)execute_392, (funcp)execute_373, (funcp)execute_376, (funcp)execute_379, (funcp)execute_382, (funcp)execute_385, (funcp)execute_391, (funcp)execute_387, (funcp)execute_388, (funcp)execute_389, (funcp)execute_403, (funcp)execute_405, (funcp)execute_1090, (funcp)execute_1091, (funcp)execute_1115, (funcp)execute_1116, (funcp)execute_1122, (funcp)execute_1123, (funcp)execute_1134, (funcp)execute_1135, (funcp)execute_1136, (funcp)execute_1137, (funcp)execute_1138, (funcp)execute_1139, (funcp)execute_1140, (funcp)execute_5027, (funcp)execute_5028, (funcp)execute_5029, (funcp)execute_5030, (funcp)execute_5031, (funcp)execute_5025, (funcp)execute_1785, (funcp)execute_1786, (funcp)execute_1787, (funcp)execute_1788, (funcp)execute_1146, (funcp)execute_1147, (funcp)execute_1148, (funcp)execute_1149, (funcp)execute_1353, (funcp)execute_1557, (funcp)execute_1558, (funcp)execute_1559, (funcp)execute_1560, (funcp)execute_1561, (funcp)execute_1766, (funcp)execute_1767, (funcp)execute_1768, (funcp)execute_1769, (funcp)execute_1776, (funcp)execute_1777, (funcp)execute_1783, (funcp)execute_1784, (funcp)execute_2432, (funcp)execute_2433, (funcp)execute_2434, (funcp)execute_2435, (funcp)execute_1793, (funcp)execute_1794, (funcp)execute_1795, (funcp)execute_1796, (funcp)execute_2000, (funcp)execute_2204, (funcp)execute_2205, (funcp)execute_2206, (funcp)execute_2207, (funcp)execute_2208, (funcp)execute_3079, (funcp)execute_3080, (funcp)execute_3081, (funcp)execute_3082, (funcp)execute_2440, (funcp)execute_2441, (funcp)execute_2442, (funcp)execute_2443, (funcp)execute_2647, (funcp)execute_2851, (funcp)execute_2852, (funcp)execute_2853, (funcp)execute_2854, (funcp)execute_2855, (funcp)execute_3726, (funcp)execute_3727, (funcp)execute_3728, (funcp)execute_3729, (funcp)execute_3087, (funcp)execute_3088, (funcp)execute_3089, (funcp)execute_3090, (funcp)execute_3294, (funcp)execute_3498, (funcp)execute_3499, (funcp)execute_3500, (funcp)execute_3501, (funcp)execute_3502, (funcp)execute_4373, (funcp)execute_4374, (funcp)execute_4375, (funcp)execute_4376, (funcp)execute_3734, (funcp)execute_3735, (funcp)execute_3736, (funcp)execute_3737, (funcp)execute_3941, (funcp)execute_4145, (funcp)execute_4146, (funcp)execute_4147, (funcp)execute_4148, (funcp)execute_4149, (funcp)execute_5020, (funcp)execute_5021, (funcp)execute_5022, (funcp)execute_5023, (funcp)execute_4381, (funcp)execute_4382, (funcp)execute_4383, (funcp)execute_4384, (funcp)execute_4588, (funcp)execute_4792, (funcp)execute_4793, (funcp)execute_4794, (funcp)execute_4795, (funcp)execute_4796, (funcp)execute_5033, (funcp)execute_5034, (funcp)execute_5041, (funcp)execute_5503, (funcp)execute_5612, (funcp)execute_5613, (funcp)execute_5614, (funcp)execute_5615, (funcp)execute_5044, (funcp)execute_5045, (funcp)execute_5046, (funcp)execute_5047, (funcp)execute_5455, (funcp)execute_5463, (funcp)execute_5471, (funcp)execute_5501, (funcp)execute_5497, (funcp)execute_5499, (funcp)execute_5482, (funcp)execute_5506, (funcp)execute_5507, (funcp)execute_5511, (funcp)execute_5515, (funcp)execute_5519, (funcp)execute_5523, (funcp)execute_5527, (funcp)execute_5531, (funcp)execute_5535, (funcp)execute_5539, (funcp)execute_5547, (funcp)execute_5548, (funcp)execute_5038, (funcp)transaction_0, (funcp)transaction_3, (funcp)transaction_4, (funcp)transaction_5, (funcp)transaction_6, (funcp)transaction_7, (funcp)vhdl_transfunc_eventcallback, (funcp)transaction_35, (funcp)transaction_36};
const int NumRelocateId= 288;

void relocate(char *dp)
{
	iki_relocate(dp, "xsim.dir/test_cordic_behav/xsim.reloc",  (void **)funcTab, 288);
	iki_vhdl_file_variable_register(dp + 536736);
	iki_vhdl_file_variable_register(dp + 536792);


	/*Populate the transaction function pointer field in the whole net structure */
}

void sensitize(char *dp)
{
	iki_sensitize(dp, "xsim.dir/test_cordic_behav/xsim.reloc");
}

void simulate(char *dp)
{
	iki_schedule_processes_at_time_zero(dp, "xsim.dir/test_cordic_behav/xsim.reloc");
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
    iki_set_sv_type_file_path_name("xsim.dir/test_cordic_behav/xsim.svtype");
    iki_set_crvs_dump_file_path_name("xsim.dir/test_cordic_behav/xsim.crvsdump");
    void* design_handle = iki_create_design("xsim.dir/test_cordic_behav/xsim.mem", (void *)relocate, (void *)sensitize, (void *)simulate, 0, isimBridge_getWdbWriter(), 0, argc, argv);
     iki_set_rc_trial_count(100);
    (void) design_handle;
    return iki_simulate_design();
}
