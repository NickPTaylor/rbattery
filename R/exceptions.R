abort_bad_argument_type <- function(arg, must_be) {

    arg_name <- deparse(substitute(arg))
    not = typeof(arg)
    msg <- glue::glue("type of `{arg_name}` must be `{must_be}`; not `{not}`")

    rlang::abort(
        "error_bad_argument_type",
        message = msg,
        arg = arg_name,
        must_be = must_be,
        not = not
    )
}

abort_bad_column_type <- function(column, in_df, must_be) {
    in_df_name <- deparse(substitute(in_df))
    not = typeof(in_df[[column]])
    msg <- glue::glue("type of `{column}` in `{in_df_name}` must be \\
                      {must_be}; not `{not}`")

    rlang::abort(
        "error_bad_column_type",
        message = msg,
        column = column,
        in_df = in_df_name,
        must_be = must_be,
        not = not
    )
}

abort_bad_shape <- function(obj, FUN, must_be) {

    obj_name <- deparse(substitute(obj))
    fun_name <- deparse(substitute(FUN))
    not = FUN(obj)
    msg <- glue::glue("{fun_name} of `{obj_name}` must be {must_be}; \\
                       not {not}")
    rlang::abort(
        "error_bad_shape",
        message = msg,
        check = fun_name,
        obj = obj_name,
        must_be = must_be,
        not = not
    )

}

abort_bad_name <- function(name, not_in_df) {
    not_in_df_name <- deparse(substitute(not_in_df))
    msg <- glue::glue("Expected `{name}` to be in `{not_in_df_name}`; \\
                      not found.")

    rlang::abort(
        "error_bad_name",
        message = msg,
        name = name,
        not_in_df = not_in_df_name
    )

}

abort_out_of_range <- function(var, must_be, not = NULL, comment = NULL) {
    msg <- glue::glue("`{var}` must be {must_be}")
    if (!is.null(not)) {
        msg <- glue::glue("{msg}; not {not}")
    }
    if (!is.null(comment)) {
        msg <- glue::glue("{msg}.  {comment}.")
    }
    rlang::abort(
        "error_out_of_range",
        message = msg,
        var = var,
        must_be = must_be,
        not = not,
        comment = comment
    )

}

abort_no_solution <- function(status) {
    msg <- glue::glue("Unable to solve.  Status: {status}")
    rlang::abort(
        "error_no_solution",
        message = msg,
        status = status
    )
}