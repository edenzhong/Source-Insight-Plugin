/**
all the macros in this file are for indicating key binding.
the macro name combined by 3 parts:
all macros start from a "a_". by this indication, we can easily distinguish the macro need to bind
a key or not in the Option->Key Assingment menu. 

the 2nd part is the key information.
a = alt
c = ctrl
chars followed "_" are the specified key

the 3rd part is the function name

*/
macro a_a_x_extend_cmd()
{
  ExtendCmd()
}

macro a_s_enter_auto_curly_brace()
{
  ui_auto_curly_brace()
}

macro a_a_i_ins_include()
{
  ins_include()
}

macro a_as_i_ins_include_sys()
{
  ins_include_sys()
}

macro a_ca_space_ins_space_after_cursor()
{
  ins_space_after_cursor()
}

macro a_a_r_ins_return()
{
  ins_return()
}


macro a_as_r_ins_curly_return()
{
  ins_curly_return()
}

macro a_a_d_ins_define()
{
  ins_define()
}

macro a_f11_dos_here()
{
  dos_here()
}

macro a_a_semicolon_ins_c_cmt()
{
  ui_ins_c_cmt()
}
macro a_c_semicolon_clr_c_cmt()
{
  ui_clr_c_cmt
}
macro a_a_enter_set_blk_parenthesis()
{
  set_blk_parenthesis()
}
macro a_a_single_quote_mk_wrap()
{
  mk_wrap()
}
macro a_c_single_quote_del_parenthesis()
{
  del_parenthesis()
}

macro a_a_1_set_if_0()
{
  set_if_0()
}
macro a_as_1_clr_if_0()
{
  clr_if_0()
}

macro a_a_f_find_char_in_line()
{
  find_char_in_line()
}
macro a_as_f_find_char_in_line_r()
{
  find_char_in_line_r()
}
macro a_ca_m_mov_to_mid_win()
{
  ui_mov_to_mid_win()
}
macro a_a_c_mul_copy()
{
  mul_copy()
}
macro a_a_v_mul_paste()
{
  mul_paste()
}
