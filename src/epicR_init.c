#include <R.h>
#include <Rinternals.h>
#include <stdlib.h> // for NULL
#include <R_ext/Rdynload.h>

/* FIXME:
 Check these declarations against the C/Fortran source code.
 */

/* .Call calls */
extern SEXP _epicUS_Callocate_resources();
extern SEXP _epicUS_Ccreate_agents();
extern SEXP _epicUS_Cdeallocate_resources();
extern SEXP _epicUS_Cdeallocate_resources2();
extern SEXP _epicUS_Cget_agent(SEXP);
extern SEXP _epicUS_Cget_agent_events(SEXP);
extern SEXP _epicUS_Cget_all_events();
extern SEXP _epicUS_Cget_all_events_matrix();
extern SEXP _epicUS_Cget_event(SEXP);
extern SEXP _epicUS_Cget_events_by_type(SEXP);
extern SEXP _epicUS_Cget_inputs();
extern SEXP _epicUS_Cget_n_events();
extern SEXP _epicUS_Cget_output();
extern SEXP _epicUS_Cget_output_ex();
extern SEXP _epicUS_Cget_pointers();
extern SEXP _epicUS_Cget_runtime_stats();
extern SEXP _epicUS_Cget_settings();
extern SEXP _epicUS_Cget_smith();
extern SEXP _epicUS_Cinit_session();
extern SEXP _epicUS_Cmodel(SEXP);
extern SEXP _epicUS_Cset_input_var(SEXP, SEXP);
extern SEXP _epicUS_Cset_settings_var(SEXP, SEXP);
extern SEXP _epicUS_get_sample_output(SEXP, SEXP);
extern SEXP _epicUS_mvrnormArma(SEXP, SEXP, SEXP);
extern SEXP _epicUS_Xrexp(SEXP, SEXP);

static const R_CallMethodDef CallEntries[] = {
  {"_epicUS_Callocate_resources",    (DL_FUNC) &_epicUS_Callocate_resources,    0},
  {"_epicUS_Ccreate_agents",         (DL_FUNC) &_epicUS_Ccreate_agents,         0},
  {"_epicUS_Cdeallocate_resources",  (DL_FUNC) &_epicUS_Cdeallocate_resources,  0},
  {"_epicUS_Cdeallocate_resources2", (DL_FUNC) &_epicUS_Cdeallocate_resources2, 0},
  {"_epicUS_Cget_agent",             (DL_FUNC) &_epicUS_Cget_agent,             1},
  {"_epicUS_Cget_agent_events",      (DL_FUNC) &_epicUS_Cget_agent_events,      1},
  {"_epicUS_Cget_all_events",        (DL_FUNC) &_epicUS_Cget_all_events,        0},
  {"_epicUS_Cget_all_events_matrix", (DL_FUNC) &_epicUS_Cget_all_events_matrix, 0},
  {"_epicUS_Cget_event",             (DL_FUNC) &_epicUS_Cget_event,             1},
  {"_epicUS_Cget_events_by_type",    (DL_FUNC) &_epicUS_Cget_events_by_type,    1},
  {"_epicUS_Cget_inputs",            (DL_FUNC) &_epicUS_Cget_inputs,            0},
  {"_epicUS_Cget_n_events",          (DL_FUNC) &_epicUS_Cget_n_events,          0},
  {"_epicUS_Cget_output",            (DL_FUNC) &_epicUS_Cget_output,            0},
  {"_epicUS_Cget_output_ex",         (DL_FUNC) &_epicUS_Cget_output_ex,         0},
  {"_epicUS_Cget_pointers",          (DL_FUNC) &_epicUS_Cget_pointers,          0},
  {"_epicUS_Cget_runtime_stats",     (DL_FUNC) &_epicUS_Cget_runtime_stats,     0},
  {"_epicUS_Cget_settings",          (DL_FUNC) &_epicUS_Cget_settings,          0},
  {"_epicUS_Cget_smith",             (DL_FUNC) &_epicUS_Cget_smith,             0},
  {"_epicUS_Cinit_session",          (DL_FUNC) &_epicUS_Cinit_session,          0},
  {"_epicUS_Cmodel",                 (DL_FUNC) &_epicUS_Cmodel,                 1},
  {"_epicUS_Cset_input_var",         (DL_FUNC) &_epicUS_Cset_input_var,         2},
  {"_epicUS_Cset_settings_var",      (DL_FUNC) &_epicUS_Cset_settings_var,      2},
  {"_epicUS_get_sample_output",      (DL_FUNC) &_epicUS_get_sample_output,      2},
  {"_epicUS_mvrnormArma",            (DL_FUNC) &_epicUS_mvrnormArma,            3},
  {"_epicUS_Xrexp",                  (DL_FUNC) &_epicUS_Xrexp,                  2},
  {NULL, NULL, 0}
};

void R_init_epicUS(DllInfo *dll)
{
  R_registerRoutines(dll, NULL, CallEntries, NULL, NULL);
  R_useDynamicSymbols(dll, FALSE);
}
