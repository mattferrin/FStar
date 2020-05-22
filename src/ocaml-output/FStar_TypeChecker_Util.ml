open Prims
type lcomp_with_binder =
  (FStar_Syntax_Syntax.bv FStar_Pervasives_Native.option *
    FStar_TypeChecker_Common.lcomp)
let (report : FStar_TypeChecker_Env.env -> Prims.string Prims.list -> unit) =
  fun env ->
    fun errs ->
      let uu____22 = FStar_TypeChecker_Env.get_range env in
      let uu____23 = FStar_TypeChecker_Err.failed_to_prove_specification errs in
      FStar_Errors.log_issue uu____22 uu____23
let (new_implicit_var :
  Prims.string ->
    FStar_Range.range ->
      FStar_TypeChecker_Env.env ->
        FStar_Syntax_Syntax.typ ->
          (FStar_Syntax_Syntax.term * (FStar_Syntax_Syntax.ctx_uvar *
            FStar_Range.range) Prims.list * FStar_TypeChecker_Common.guard_t))
  =
  fun reason ->
    fun r ->
      fun env ->
        fun k ->
          FStar_TypeChecker_Env.new_implicit_var_aux reason r env k
            FStar_Syntax_Syntax.Strict FStar_Pervasives_Native.None
let (close_guard_implicits :
  FStar_TypeChecker_Env.env ->
    Prims.bool ->
      FStar_Syntax_Syntax.binders ->
        FStar_TypeChecker_Common.guard_t -> FStar_TypeChecker_Common.guard_t)
  =
  fun env ->
    fun solve_deferred ->
      fun xs ->
        fun g ->
          let uu____87 = (FStar_Options.eager_subtyping ()) || solve_deferred in
          if uu____87
          then
            let uu____90 =
              FStar_All.pipe_right g.FStar_TypeChecker_Common.deferred
                (FStar_List.partition
                   (fun uu____142 ->
                      match uu____142 with
                      | (uu____149, p) ->
                          FStar_TypeChecker_Rel.flex_prob_closing env xs p)) in
            match uu____90 with
            | (solve_now, defer) ->
                ((let uu____184 =
                    FStar_All.pipe_left (FStar_TypeChecker_Env.debug env)
                      (FStar_Options.Other "Rel") in
                  if uu____184
                  then
                    (FStar_Util.print_string "SOLVE BEFORE CLOSING:\n";
                     FStar_List.iter
                       (fun uu____201 ->
                          match uu____201 with
                          | (s, p) ->
                              let uu____211 =
                                FStar_TypeChecker_Rel.prob_to_string env p in
                              FStar_Util.print2 "%s: %s\n" s uu____211)
                       solve_now;
                     FStar_Util.print_string " ...DEFERRED THE REST:\n";
                     FStar_List.iter
                       (fun uu____226 ->
                          match uu____226 with
                          | (s, p) ->
                              let uu____236 =
                                FStar_TypeChecker_Rel.prob_to_string env p in
                              FStar_Util.print2 "%s: %s\n" s uu____236) defer;
                     FStar_Util.print_string "END\n")
                  else ());
                 (let g1 =
                    FStar_TypeChecker_Rel.solve_deferred_constraints env
                      (let uu___49_244 = g in
                       {
                         FStar_TypeChecker_Common.guard_f =
                           (uu___49_244.FStar_TypeChecker_Common.guard_f);
                         FStar_TypeChecker_Common.deferred_to_tac =
                           (uu___49_244.FStar_TypeChecker_Common.deferred_to_tac);
                         FStar_TypeChecker_Common.deferred = solve_now;
                         FStar_TypeChecker_Common.univ_ineqs =
                           (uu___49_244.FStar_TypeChecker_Common.univ_ineqs);
                         FStar_TypeChecker_Common.implicits =
                           (uu___49_244.FStar_TypeChecker_Common.implicits)
                       }) in
                  let g2 =
                    let uu___52_246 = g1 in
                    {
                      FStar_TypeChecker_Common.guard_f =
                        (uu___52_246.FStar_TypeChecker_Common.guard_f);
                      FStar_TypeChecker_Common.deferred_to_tac =
                        (uu___52_246.FStar_TypeChecker_Common.deferred_to_tac);
                      FStar_TypeChecker_Common.deferred = defer;
                      FStar_TypeChecker_Common.univ_ineqs =
                        (uu___52_246.FStar_TypeChecker_Common.univ_ineqs);
                      FStar_TypeChecker_Common.implicits =
                        (uu___52_246.FStar_TypeChecker_Common.implicits)
                    } in
                  g2))
          else g
let (check_uvars : FStar_Range.range -> FStar_Syntax_Syntax.typ -> unit) =
  fun r ->
    fun t ->
      let uvs = FStar_Syntax_Free.uvars t in
      let uu____263 =
        let uu____265 = FStar_Util.set_is_empty uvs in
        Prims.op_Negation uu____265 in
      if uu____263
      then
        let us =
          let uu____270 =
            let uu____274 = FStar_Util.set_elements uvs in
            FStar_List.map
              (fun u ->
                 FStar_Syntax_Print.uvar_to_string
                   u.FStar_Syntax_Syntax.ctx_uvar_head) uu____274 in
          FStar_All.pipe_right uu____270 (FStar_String.concat ", ") in
        (FStar_Options.push ();
         FStar_Options.set_option "hide_uvar_nums" (FStar_Options.Bool false);
         FStar_Options.set_option "print_implicits" (FStar_Options.Bool true);
         (let uu____293 =
            let uu____299 =
              let uu____301 = FStar_Syntax_Print.term_to_string t in
              FStar_Util.format2
                "Unconstrained unification variables %s in type signature %s; please add an annotation"
                us uu____301 in
            (FStar_Errors.Error_UncontrainedUnificationVar, uu____299) in
          FStar_Errors.log_issue r uu____293);
         FStar_Options.pop ())
      else ()
let (extract_let_rec_annotation :
  FStar_TypeChecker_Env.env ->
    FStar_Syntax_Syntax.letbinding ->
      (FStar_Syntax_Syntax.univ_names * FStar_Syntax_Syntax.typ * Prims.bool))
  =
  fun env ->
    fun uu____324 ->
      match uu____324 with
      | { FStar_Syntax_Syntax.lbname = lbname;
          FStar_Syntax_Syntax.lbunivs = univ_vars;
          FStar_Syntax_Syntax.lbtyp = t;
          FStar_Syntax_Syntax.lbeff = uu____335;
          FStar_Syntax_Syntax.lbdef = e;
          FStar_Syntax_Syntax.lbattrs = uu____337;
          FStar_Syntax_Syntax.lbpos = uu____338;_} ->
          let rng = FStar_Syntax_Syntax.range_of_lbname lbname in
          let t1 = FStar_Syntax_Subst.compress t in
          (match t1.FStar_Syntax_Syntax.n with
           | FStar_Syntax_Syntax.Tm_unknown ->
               let uu____373 = FStar_Syntax_Subst.open_univ_vars univ_vars e in
               (match uu____373 with
                | (univ_vars1, e1) ->
                    let env1 =
                      FStar_TypeChecker_Env.push_univ_vars env univ_vars1 in
                    let r = FStar_TypeChecker_Env.get_range env1 in
                    let rec aux e2 =
                      let e3 = FStar_Syntax_Subst.compress e2 in
                      match e3.FStar_Syntax_Syntax.n with
                      | FStar_Syntax_Syntax.Tm_meta (e4, uu____411) -> aux e4
                      | FStar_Syntax_Syntax.Tm_ascribed (e4, t2, uu____418)
                          -> FStar_Pervasives_Native.fst t2
                      | FStar_Syntax_Syntax.Tm_abs (bs, body, uu____473) ->
                          let res = aux body in
                          let c =
                            match res with
                            | FStar_Util.Inl t2 ->
                                let uu____509 = FStar_Options.ml_ish () in
                                if uu____509
                                then FStar_Syntax_Util.ml_comp t2 r
                                else FStar_Syntax_Syntax.mk_Total t2
                            | FStar_Util.Inr c -> c in
                          let t2 =
                            FStar_Syntax_Syntax.mk
                              (FStar_Syntax_Syntax.Tm_arrow (bs, c))
                              c.FStar_Syntax_Syntax.pos in
                          ((let uu____531 =
                              FStar_TypeChecker_Env.debug env1
                                FStar_Options.High in
                            if uu____531
                            then
                              let uu____534 = FStar_Range.string_of_range r in
                              let uu____536 =
                                FStar_Syntax_Print.term_to_string t2 in
                              FStar_Util.print2 "(%s) Using type %s\n"
                                uu____534 uu____536
                            else ());
                           FStar_Util.Inl t2)
                      | uu____541 -> FStar_Util.Inl FStar_Syntax_Syntax.tun in
                    let t2 =
                      let uu____543 = aux e1 in
                      match uu____543 with
                      | FStar_Util.Inr c ->
                          let uu____549 =
                            FStar_Syntax_Util.is_tot_or_gtot_comp c in
                          if uu____549
                          then FStar_Syntax_Util.comp_result c
                          else
                            (let uu____554 =
                               let uu____560 =
                                 let uu____562 =
                                   FStar_Syntax_Print.comp_to_string c in
                                 FStar_Util.format1
                                   "Expected a 'let rec' to be annotated with a value type; got a computation type %s"
                                   uu____562 in
                               (FStar_Errors.Fatal_UnexpectedComputationTypeForLetRec,
                                 uu____560) in
                             FStar_Errors.raise_error uu____554 rng)
                      | FStar_Util.Inl t2 -> t2 in
                    (univ_vars1, t2, true))
           | uu____571 ->
               let uu____572 = FStar_Syntax_Subst.open_univ_vars univ_vars t1 in
               (match uu____572 with
                | (univ_vars1, t2) -> (univ_vars1, t2, false)))
let rec (decorated_pattern_as_term :
  FStar_Syntax_Syntax.pat ->
    (FStar_Syntax_Syntax.bv Prims.list * FStar_Syntax_Syntax.term))
  =
  fun pat ->
    let mk f = FStar_Syntax_Syntax.mk f pat.FStar_Syntax_Syntax.p in
    let pat_as_arg uu____636 =
      match uu____636 with
      | (p, i) ->
          let uu____656 = decorated_pattern_as_term p in
          (match uu____656 with
           | (vars, te) ->
               let uu____679 =
                 let uu____684 = FStar_Syntax_Syntax.as_implicit i in
                 (te, uu____684) in
               (vars, uu____679)) in
    match pat.FStar_Syntax_Syntax.v with
    | FStar_Syntax_Syntax.Pat_constant c ->
        let uu____698 = mk (FStar_Syntax_Syntax.Tm_constant c) in
        ([], uu____698)
    | FStar_Syntax_Syntax.Pat_wild x ->
        let uu____702 = mk (FStar_Syntax_Syntax.Tm_name x) in
        ([x], uu____702)
    | FStar_Syntax_Syntax.Pat_var x ->
        let uu____706 = mk (FStar_Syntax_Syntax.Tm_name x) in
        ([x], uu____706)
    | FStar_Syntax_Syntax.Pat_cons (fv, pats) ->
        let uu____729 =
          let uu____748 =
            FStar_All.pipe_right pats (FStar_List.map pat_as_arg) in
          FStar_All.pipe_right uu____748 FStar_List.unzip in
        (match uu____729 with
         | (vars, args) ->
             let vars1 = FStar_List.flatten vars in
             let uu____886 =
               let uu____887 =
                 let uu____888 =
                   let uu____905 = FStar_Syntax_Syntax.fv_to_tm fv in
                   (uu____905, args) in
                 FStar_Syntax_Syntax.Tm_app uu____888 in
               mk uu____887 in
             (vars1, uu____886))
    | FStar_Syntax_Syntax.Pat_dot_term (x, e) -> ([], e)
let (comp_univ_opt :
  FStar_Syntax_Syntax.comp' FStar_Syntax_Syntax.syntax ->
    FStar_Syntax_Syntax.universe FStar_Pervasives_Native.option)
  =
  fun c ->
    match c.FStar_Syntax_Syntax.n with
    | FStar_Syntax_Syntax.Total (uu____944, uopt) -> uopt
    | FStar_Syntax_Syntax.GTotal (uu____954, uopt) -> uopt
    | FStar_Syntax_Syntax.Comp c1 ->
        (match c1.FStar_Syntax_Syntax.comp_univs with
         | [] -> FStar_Pervasives_Native.None
         | hd::uu____968 -> FStar_Pervasives_Native.Some hd)
let (lcomp_univ_opt :
  FStar_TypeChecker_Common.lcomp ->
    (FStar_Syntax_Syntax.universe FStar_Pervasives_Native.option *
      FStar_TypeChecker_Common.guard_t))
  =
  fun lc ->
    let uu____983 =
      FStar_All.pipe_right lc FStar_TypeChecker_Common.lcomp_comp in
    FStar_All.pipe_right uu____983
      (fun uu____1011 ->
         match uu____1011 with | (c, g) -> ((comp_univ_opt c), g))
let (destruct_wp_comp :
  FStar_Syntax_Syntax.comp_typ ->
    (FStar_Syntax_Syntax.universe * FStar_Syntax_Syntax.typ *
      FStar_Syntax_Syntax.typ))
  = fun c -> FStar_Syntax_Util.destruct_comp c
let (mk_comp_l :
  FStar_Ident.lident ->
    FStar_Syntax_Syntax.universe ->
      FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax ->
        FStar_Syntax_Syntax.term ->
          FStar_Syntax_Syntax.cflag Prims.list -> FStar_Syntax_Syntax.comp)
  =
  fun mname ->
    fun u_result ->
      fun result ->
        fun wp ->
          fun flags ->
            let uu____1084 =
              let uu____1085 =
                let uu____1096 = FStar_Syntax_Syntax.as_arg wp in
                [uu____1096] in
              {
                FStar_Syntax_Syntax.comp_univs = [u_result];
                FStar_Syntax_Syntax.effect_name = mname;
                FStar_Syntax_Syntax.result_typ = result;
                FStar_Syntax_Syntax.effect_args = uu____1085;
                FStar_Syntax_Syntax.flags = flags
              } in
            FStar_Syntax_Syntax.mk_Comp uu____1084
let (mk_comp :
  FStar_Syntax_Syntax.eff_decl ->
    FStar_Syntax_Syntax.universe ->
      FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax ->
        FStar_Syntax_Syntax.term ->
          FStar_Syntax_Syntax.cflag Prims.list -> FStar_Syntax_Syntax.comp)
  = fun md -> mk_comp_l md.FStar_Syntax_Syntax.mname
let (effect_args_from_repr :
  FStar_Syntax_Syntax.term ->
    Prims.bool -> FStar_Range.range -> FStar_Syntax_Syntax.term Prims.list)
  =
  fun repr ->
    fun is_layered ->
      fun r ->
        let err uu____1180 =
          let uu____1181 =
            let uu____1187 =
              let uu____1189 = FStar_Syntax_Print.term_to_string repr in
              let uu____1191 = FStar_Util.string_of_bool is_layered in
              FStar_Util.format2
                "Could not get effect args from repr %s with is_layered %s"
                uu____1189 uu____1191 in
            (FStar_Errors.Fatal_UnexpectedEffect, uu____1187) in
          FStar_Errors.raise_error uu____1181 r in
        let repr1 = FStar_Syntax_Subst.compress repr in
        if is_layered
        then
          match repr1.FStar_Syntax_Syntax.n with
          | FStar_Syntax_Syntax.Tm_app (uu____1203, uu____1204::is) ->
              FStar_All.pipe_right is
                (FStar_List.map FStar_Pervasives_Native.fst)
          | uu____1272 -> err ()
        else
          (match repr1.FStar_Syntax_Syntax.n with
           | FStar_Syntax_Syntax.Tm_arrow (uu____1277, c) ->
               let uu____1299 =
                 FStar_All.pipe_right c FStar_Syntax_Util.comp_to_comp_typ in
               FStar_All.pipe_right uu____1299
                 (fun ct ->
                    FStar_All.pipe_right ct.FStar_Syntax_Syntax.effect_args
                      (FStar_List.map FStar_Pervasives_Native.fst))
           | uu____1334 -> err ())
let (mk_wp_return :
  FStar_TypeChecker_Env.env ->
    FStar_Syntax_Syntax.eff_decl ->
      FStar_Syntax_Syntax.universe ->
        FStar_Syntax_Syntax.typ ->
          FStar_Syntax_Syntax.term ->
            FStar_Range.range -> FStar_Syntax_Syntax.comp)
  =
  fun env ->
    fun ed ->
      fun u_a ->
        fun a ->
          fun e ->
            fun r ->
              let c =
                let uu____1367 =
                  let uu____1369 =
                    FStar_TypeChecker_Env.lid_exists env
                      FStar_Parser_Const.effect_GTot_lid in
                  FStar_All.pipe_left Prims.op_Negation uu____1369 in
                if uu____1367
                then FStar_Syntax_Syntax.mk_Total a
                else
                  (let uu____1376 = FStar_Syntax_Util.is_unit a in
                   if uu____1376
                   then
                     FStar_Syntax_Syntax.mk_Total' a
                       (FStar_Pervasives_Native.Some
                          FStar_Syntax_Syntax.U_zero)
                   else
                     (let wp =
                        let uu____1382 =
                          env.FStar_TypeChecker_Env.lax &&
                            (FStar_Options.ml_ish ()) in
                        if uu____1382
                        then FStar_Syntax_Syntax.tun
                        else
                          (let ret_wp =
                             FStar_All.pipe_right ed
                               FStar_Syntax_Util.get_return_vc_combinator in
                           let uu____1388 =
                             let uu____1389 =
                               FStar_TypeChecker_Env.inst_effect_fun_with
                                 [u_a] env ed ret_wp in
                             let uu____1390 =
                               let uu____1391 = FStar_Syntax_Syntax.as_arg a in
                               let uu____1400 =
                                 let uu____1411 =
                                   FStar_Syntax_Syntax.as_arg e in
                                 [uu____1411] in
                               uu____1391 :: uu____1400 in
                             FStar_Syntax_Syntax.mk_Tm_app uu____1389
                               uu____1390 e.FStar_Syntax_Syntax.pos in
                           FStar_TypeChecker_Normalize.normalize
                             [FStar_TypeChecker_Env.Beta;
                             FStar_TypeChecker_Env.NoFullNorm] env uu____1388) in
                      mk_comp ed u_a a wp [FStar_Syntax_Syntax.RETURN])) in
              (let uu____1445 =
                 FStar_All.pipe_left (FStar_TypeChecker_Env.debug env)
                   (FStar_Options.Other "Return") in
               if uu____1445
               then
                 let uu____1450 =
                   FStar_Range.string_of_range e.FStar_Syntax_Syntax.pos in
                 let uu____1452 = FStar_Syntax_Print.term_to_string e in
                 let uu____1454 =
                   FStar_TypeChecker_Normalize.comp_to_string env c in
                 FStar_Util.print3 "(%s) returning %s at comp type %s\n"
                   uu____1450 uu____1452 uu____1454
               else ());
              c
let (mk_indexed_return :
  FStar_TypeChecker_Env.env ->
    FStar_Syntax_Syntax.eff_decl ->
      FStar_Syntax_Syntax.universe ->
        FStar_Syntax_Syntax.typ ->
          FStar_Syntax_Syntax.term ->
            FStar_Range.range ->
              (FStar_Syntax_Syntax.comp * FStar_TypeChecker_Common.guard_t))
  =
  fun env ->
    fun ed ->
      fun u_a ->
        fun a ->
          fun e ->
            fun r ->
              (let uu____1499 =
                 FStar_All.pipe_left (FStar_TypeChecker_Env.debug env)
                   (FStar_Options.Other "LayeredEffects") in
               if uu____1499
               then
                 let uu____1504 =
                   FStar_Ident.string_of_lid ed.FStar_Syntax_Syntax.mname in
                 let uu____1506 = FStar_Syntax_Print.univ_to_string u_a in
                 let uu____1508 = FStar_Syntax_Print.term_to_string a in
                 let uu____1510 = FStar_Syntax_Print.term_to_string e in
                 FStar_Util.print4
                   "Computing %s.return for u_a:%s, a:%s, and e:%s{\n"
                   uu____1504 uu____1506 uu____1508 uu____1510
               else ());
              (let uu____1515 =
                 let uu____1520 =
                   FStar_All.pipe_right ed
                     FStar_Syntax_Util.get_return_vc_combinator in
                 FStar_TypeChecker_Env.inst_tscheme_with uu____1520 [u_a] in
               match uu____1515 with
               | (uu____1525, return_t) ->
                   let return_t_shape_error s =
                     let uu____1540 =
                       let uu____1542 =
                         FStar_Ident.string_of_lid
                           ed.FStar_Syntax_Syntax.mname in
                       let uu____1544 =
                         FStar_Syntax_Print.term_to_string return_t in
                       FStar_Util.format3
                         "%s.return %s does not have proper shape (reason:%s)"
                         uu____1542 uu____1544 s in
                     (FStar_Errors.Fatal_UnexpectedEffect, uu____1540) in
                   let uu____1548 =
                     let uu____1577 =
                       let uu____1578 = FStar_Syntax_Subst.compress return_t in
                       uu____1578.FStar_Syntax_Syntax.n in
                     match uu____1577 with
                     | FStar_Syntax_Syntax.Tm_arrow (bs, c) when
                         (FStar_List.length bs) >= (Prims.of_int (2)) ->
                         let uu____1638 = FStar_Syntax_Subst.open_comp bs c in
                         (match uu____1638 with
                          | (a_b::x_b::bs1, c1) ->
                              let uu____1707 =
                                FStar_Syntax_Util.comp_to_comp_typ c1 in
                              (a_b, x_b, bs1, uu____1707))
                     | uu____1728 ->
                         let uu____1729 =
                           return_t_shape_error
                             "Either not an arrow or not enough binders" in
                         FStar_Errors.raise_error uu____1729 r in
                   (match uu____1548 with
                    | (a_b, x_b, rest_bs, return_ct) ->
                        let uu____1812 =
                          let uu____1819 =
                            let uu____1820 =
                              let uu____1821 =
                                let uu____1828 =
                                  FStar_All.pipe_right a_b
                                    FStar_Pervasives_Native.fst in
                                (uu____1828, a) in
                              FStar_Syntax_Syntax.NT uu____1821 in
                            let uu____1839 =
                              let uu____1842 =
                                let uu____1843 =
                                  let uu____1850 =
                                    FStar_All.pipe_right x_b
                                      FStar_Pervasives_Native.fst in
                                  (uu____1850, e) in
                                FStar_Syntax_Syntax.NT uu____1843 in
                              [uu____1842] in
                            uu____1820 :: uu____1839 in
                          FStar_TypeChecker_Env.uvars_for_binders env rest_bs
                            uu____1819
                            (fun b ->
                               let uu____1866 =
                                 FStar_Syntax_Print.binder_to_string b in
                               let uu____1868 =
                                 let uu____1870 =
                                   FStar_Ident.string_of_lid
                                     ed.FStar_Syntax_Syntax.mname in
                                 FStar_Util.format1 "%s.return" uu____1870 in
                               let uu____1873 = FStar_Range.string_of_range r in
                               FStar_Util.format3
                                 "implicit var for binder %s of %s at %s"
                                 uu____1866 uu____1868 uu____1873) r in
                        (match uu____1812 with
                         | (rest_bs_uvars, g_uvars) ->
                             let subst =
                               FStar_List.map2
                                 (fun b ->
                                    fun t ->
                                      let uu____1910 =
                                        let uu____1917 =
                                          FStar_All.pipe_right b
                                            FStar_Pervasives_Native.fst in
                                        (uu____1917, t) in
                                      FStar_Syntax_Syntax.NT uu____1910) (a_b
                                 :: x_b :: rest_bs) (a :: e :: rest_bs_uvars) in
                             let is =
                               let uu____1943 =
                                 let uu____1946 =
                                   FStar_Syntax_Subst.compress
                                     return_ct.FStar_Syntax_Syntax.result_typ in
                                 let uu____1947 =
                                   FStar_Syntax_Util.is_layered ed in
                                 effect_args_from_repr uu____1946 uu____1947
                                   r in
                               FStar_All.pipe_right uu____1943
                                 (FStar_List.map
                                    (FStar_Syntax_Subst.subst subst)) in
                             let c =
                               let uu____1954 =
                                 let uu____1955 =
                                   FStar_All.pipe_right is
                                     (FStar_List.map
                                        FStar_Syntax_Syntax.as_arg) in
                                 {
                                   FStar_Syntax_Syntax.comp_univs = [u_a];
                                   FStar_Syntax_Syntax.effect_name =
                                     (ed.FStar_Syntax_Syntax.mname);
                                   FStar_Syntax_Syntax.result_typ = a;
                                   FStar_Syntax_Syntax.effect_args =
                                     uu____1955;
                                   FStar_Syntax_Syntax.flags = []
                                 } in
                               FStar_Syntax_Syntax.mk_Comp uu____1954 in
                             ((let uu____1979 =
                                 FStar_All.pipe_left
                                   (FStar_TypeChecker_Env.debug env)
                                   (FStar_Options.Other "LayeredEffects") in
                               if uu____1979
                               then
                                 let uu____1984 =
                                   FStar_Syntax_Print.comp_to_string c in
                                 FStar_Util.print1 "} c after return %s\n"
                                   uu____1984
                               else ());
                              (c, g_uvars)))))
let (mk_return :
  FStar_TypeChecker_Env.env ->
    FStar_Syntax_Syntax.eff_decl ->
      FStar_Syntax_Syntax.universe ->
        FStar_Syntax_Syntax.typ ->
          FStar_Syntax_Syntax.term ->
            FStar_Range.range ->
              (FStar_Syntax_Syntax.comp * FStar_TypeChecker_Common.guard_t))
  =
  fun env ->
    fun ed ->
      fun u_a ->
        fun a ->
          fun e ->
            fun r ->
              let uu____2028 =
                FStar_All.pipe_right ed FStar_Syntax_Util.is_layered in
              if uu____2028
              then mk_indexed_return env ed u_a a e r
              else
                (let uu____2038 = mk_wp_return env ed u_a a e r in
                 (uu____2038, FStar_TypeChecker_Env.trivial_guard))
let (lift_comp :
  FStar_TypeChecker_Env.env ->
    FStar_Syntax_Syntax.comp_typ ->
      FStar_TypeChecker_Env.mlift ->
        (FStar_Syntax_Syntax.comp * FStar_TypeChecker_Common.guard_t))
  =
  fun env ->
    fun c ->
      fun lift ->
        let uu____2063 =
          FStar_All.pipe_right
            (let uu___257_2065 = c in
             {
               FStar_Syntax_Syntax.comp_univs =
                 (uu___257_2065.FStar_Syntax_Syntax.comp_univs);
               FStar_Syntax_Syntax.effect_name =
                 (uu___257_2065.FStar_Syntax_Syntax.effect_name);
               FStar_Syntax_Syntax.result_typ =
                 (uu___257_2065.FStar_Syntax_Syntax.result_typ);
               FStar_Syntax_Syntax.effect_args =
                 (uu___257_2065.FStar_Syntax_Syntax.effect_args);
               FStar_Syntax_Syntax.flags = []
             }) FStar_Syntax_Syntax.mk_Comp in
        FStar_All.pipe_right uu____2063
          (lift.FStar_TypeChecker_Env.mlift_wp env)
let (join_effects :
  FStar_TypeChecker_Env.env ->
    FStar_Ident.lident -> FStar_Ident.lident -> FStar_Ident.lident)
  =
  fun env ->
    fun l1_in ->
      fun l2_in ->
        let uu____2086 =
          let uu____2091 = FStar_TypeChecker_Env.norm_eff_name env l1_in in
          let uu____2092 = FStar_TypeChecker_Env.norm_eff_name env l2_in in
          (uu____2091, uu____2092) in
        match uu____2086 with
        | (l1, l2) ->
            let uu____2095 = FStar_TypeChecker_Env.join_opt env l1 l2 in
            (match uu____2095 with
             | FStar_Pervasives_Native.Some (m, uu____2105, uu____2106) -> m
             | FStar_Pervasives_Native.None ->
                 let uu____2119 =
                   FStar_TypeChecker_Env.exists_polymonadic_bind env l1 l2 in
                 (match uu____2119 with
                  | FStar_Pervasives_Native.Some (m, uu____2133) -> m
                  | FStar_Pervasives_Native.None ->
                      let uu____2166 =
                        let uu____2172 =
                          let uu____2174 =
                            FStar_Syntax_Print.lid_to_string l1_in in
                          let uu____2176 =
                            FStar_Syntax_Print.lid_to_string l2_in in
                          FStar_Util.format2
                            "Effects %s and %s cannot be composed" uu____2174
                            uu____2176 in
                        (FStar_Errors.Fatal_EffectsCannotBeComposed,
                          uu____2172) in
                      FStar_Errors.raise_error uu____2166
                        env.FStar_TypeChecker_Env.range))
let (join_lcomp :
  FStar_TypeChecker_Env.env ->
    FStar_TypeChecker_Common.lcomp ->
      FStar_TypeChecker_Common.lcomp -> FStar_Ident.lident)
  =
  fun env ->
    fun c1 ->
      fun c2 ->
        let uu____2196 =
          (FStar_TypeChecker_Common.is_total_lcomp c1) &&
            (FStar_TypeChecker_Common.is_total_lcomp c2) in
        if uu____2196
        then FStar_Parser_Const.effect_Tot_lid
        else
          join_effects env c1.FStar_TypeChecker_Common.eff_name
            c2.FStar_TypeChecker_Common.eff_name
let (lift_comps_sep_guards :
  FStar_TypeChecker_Env.env ->
    FStar_Syntax_Syntax.comp ->
      FStar_Syntax_Syntax.comp ->
        FStar_Syntax_Syntax.bv FStar_Pervasives_Native.option ->
          Prims.bool ->
            (FStar_Ident.lident * FStar_Syntax_Syntax.comp *
              FStar_Syntax_Syntax.comp * FStar_TypeChecker_Common.guard_t *
              FStar_TypeChecker_Common.guard_t))
  =
  fun env ->
    fun c1 ->
      fun c2 ->
        fun b ->
          fun for_bind ->
            let c11 = FStar_TypeChecker_Env.unfold_effect_abbrev env c1 in
            let c21 = FStar_TypeChecker_Env.unfold_effect_abbrev env c2 in
            let uu____2255 =
              FStar_TypeChecker_Env.join_opt env
                c11.FStar_Syntax_Syntax.effect_name
                c21.FStar_Syntax_Syntax.effect_name in
            match uu____2255 with
            | FStar_Pervasives_Native.Some (m, lift1, lift2) ->
                let uu____2283 = lift_comp env c11 lift1 in
                (match uu____2283 with
                 | (c12, g1) ->
                     let uu____2300 =
                       if Prims.op_Negation for_bind
                       then lift_comp env c21 lift2
                       else
                         (let x_a =
                            match b with
                            | FStar_Pervasives_Native.None ->
                                FStar_Syntax_Syntax.null_binder
                                  (FStar_Syntax_Util.comp_result c12)
                            | FStar_Pervasives_Native.Some x ->
                                FStar_Syntax_Syntax.mk_binder x in
                          let env_x =
                            FStar_TypeChecker_Env.push_binders env [x_a] in
                          let uu____2339 = lift_comp env_x c21 lift2 in
                          match uu____2339 with
                          | (c22, g2) ->
                              let uu____2350 =
                                FStar_TypeChecker_Env.close_guard env 
                                  [x_a] g2 in
                              (c22, uu____2350)) in
                     (match uu____2300 with
                      | (c22, g2) -> (m, c12, c22, g1, g2)))
            | FStar_Pervasives_Native.None ->
                let rng = env.FStar_TypeChecker_Env.range in
                let err uu____2397 =
                  let uu____2398 =
                    let uu____2404 =
                      let uu____2406 =
                        FStar_Syntax_Print.lid_to_string
                          c11.FStar_Syntax_Syntax.effect_name in
                      let uu____2408 =
                        FStar_Syntax_Print.lid_to_string
                          c21.FStar_Syntax_Syntax.effect_name in
                      FStar_Util.format2
                        "Effects %s and %s cannot be composed" uu____2406
                        uu____2408 in
                    (FStar_Errors.Fatal_EffectsCannotBeComposed, uu____2404) in
                  FStar_Errors.raise_error uu____2398 rng in
                ((let uu____2423 =
                    FStar_All.pipe_left (FStar_TypeChecker_Env.debug env)
                      (FStar_Options.Other "LayeredEffects") in
                  if uu____2423
                  then
                    let uu____2428 =
                      let uu____2430 =
                        FStar_All.pipe_right c11 FStar_Syntax_Syntax.mk_Comp in
                      FStar_All.pipe_right uu____2430
                        FStar_Syntax_Print.comp_to_string in
                    let uu____2432 =
                      let uu____2434 =
                        FStar_All.pipe_right c21 FStar_Syntax_Syntax.mk_Comp in
                      FStar_All.pipe_right uu____2434
                        FStar_Syntax_Print.comp_to_string in
                    let uu____2436 = FStar_Util.string_of_bool for_bind in
                    FStar_Util.print3
                      "Lifting comps %s and %s with for_bind %s{\n"
                      uu____2428 uu____2432 uu____2436
                  else ());
                 if for_bind
                 then err ()
                 else
                   (let bind_with_return ct ret_eff f_bind =
                      let x_bv =
                        FStar_Syntax_Syntax.gen_bv "x"
                          FStar_Pervasives_Native.None
                          ct.FStar_Syntax_Syntax.result_typ in
                      let uu____2492 =
                        let uu____2497 =
                          FStar_TypeChecker_Env.push_bv env x_bv in
                        let uu____2498 =
                          FStar_TypeChecker_Env.get_effect_decl env ret_eff in
                        let uu____2499 =
                          FStar_List.hd ct.FStar_Syntax_Syntax.comp_univs in
                        let uu____2500 = FStar_Syntax_Syntax.bv_to_name x_bv in
                        mk_return uu____2497 uu____2498 uu____2499
                          ct.FStar_Syntax_Syntax.result_typ uu____2500 rng in
                      match uu____2492 with
                      | (c_ret, g_ret) ->
                          let uu____2507 =
                            let uu____2512 =
                              FStar_Syntax_Util.comp_to_comp_typ c_ret in
                            f_bind env ct (FStar_Pervasives_Native.Some x_bv)
                              uu____2512 [] rng in
                          (match uu____2507 with
                           | (c, g_bind) ->
                               let uu____2519 =
                                 FStar_TypeChecker_Env.conj_guard g_ret
                                   g_bind in
                               (c, uu____2519)) in
                    let try_lift c12 c22 =
                      let p_bind_opt =
                        FStar_TypeChecker_Env.exists_polymonadic_bind env
                          c12.FStar_Syntax_Syntax.effect_name
                          c22.FStar_Syntax_Syntax.effect_name in
                      let uu____2564 =
                        FStar_All.pipe_right p_bind_opt FStar_Util.is_some in
                      if uu____2564
                      then
                        let uu____2600 =
                          FStar_All.pipe_right p_bind_opt FStar_Util.must in
                        match uu____2600 with
                        | (p, f_bind) ->
                            let uu____2667 =
                              FStar_Ident.lid_equals p
                                c22.FStar_Syntax_Syntax.effect_name in
                            (if uu____2667
                             then
                               let uu____2680 = bind_with_return c12 p f_bind in
                               match uu____2680 with
                               | (c13, g) ->
                                   let uu____2697 =
                                     let uu____2706 =
                                       FStar_Syntax_Syntax.mk_Comp c22 in
                                     ((c22.FStar_Syntax_Syntax.effect_name),
                                       c13, uu____2706, g) in
                                   FStar_Pervasives_Native.Some uu____2697
                             else FStar_Pervasives_Native.None)
                      else FStar_Pervasives_Native.None in
                    let uu____2735 =
                      let uu____2746 = try_lift c11 c21 in
                      match uu____2746 with
                      | FStar_Pervasives_Native.Some (p, c12, c22, g) ->
                          (p, c12, c22, g,
                            FStar_TypeChecker_Env.trivial_guard)
                      | FStar_Pervasives_Native.None ->
                          let uu____2787 = try_lift c21 c11 in
                          (match uu____2787 with
                           | FStar_Pervasives_Native.Some (p, c22, c12, g) ->
                               (p, c12, c22,
                                 FStar_TypeChecker_Env.trivial_guard, g)
                           | FStar_Pervasives_Native.None -> err ()) in
                    match uu____2735 with
                    | (p, c12, c22, g1, g2) ->
                        ((let uu____2844 =
                            FStar_All.pipe_left
                              (FStar_TypeChecker_Env.debug env)
                              (FStar_Options.Other "LayeredEffects") in
                          if uu____2844
                          then
                            let uu____2849 = FStar_Ident.string_of_lid p in
                            let uu____2851 =
                              FStar_Syntax_Print.comp_to_string c12 in
                            let uu____2853 =
                              FStar_Syntax_Print.comp_to_string c22 in
                            FStar_Util.print3
                              "} Returning p %s, c1 %s, and c2 %s\n"
                              uu____2849 uu____2851 uu____2853
                          else ());
                         (p, c12, c22, g1, g2))))
let (lift_comps :
  FStar_TypeChecker_Env.env ->
    FStar_Syntax_Syntax.comp ->
      FStar_Syntax_Syntax.comp ->
        FStar_Syntax_Syntax.bv FStar_Pervasives_Native.option ->
          Prims.bool ->
            (FStar_Ident.lident * FStar_Syntax_Syntax.comp *
              FStar_Syntax_Syntax.comp * FStar_TypeChecker_Common.guard_t))
  =
  fun env ->
    fun c1 ->
      fun c2 ->
        fun b ->
          fun for_bind ->
            let uu____2906 = lift_comps_sep_guards env c1 c2 b for_bind in
            match uu____2906 with
            | (l, c11, c21, g1, g2) ->
                let uu____2930 = FStar_TypeChecker_Env.conj_guard g1 g2 in
                (l, c11, c21, uu____2930)
let (is_pure_effect :
  FStar_TypeChecker_Env.env -> FStar_Ident.lident -> Prims.bool) =
  fun env ->
    fun l ->
      let l1 = FStar_TypeChecker_Env.norm_eff_name env l in
      FStar_Ident.lid_equals l1 FStar_Parser_Const.effect_PURE_lid
let (is_ghost_effect :
  FStar_TypeChecker_Env.env -> FStar_Ident.lident -> Prims.bool) =
  fun env ->
    fun l ->
      let l1 = FStar_TypeChecker_Env.norm_eff_name env l in
      FStar_Ident.lid_equals l1 FStar_Parser_Const.effect_GHOST_lid
let (is_pure_or_ghost_effect :
  FStar_TypeChecker_Env.env -> FStar_Ident.lident -> Prims.bool) =
  fun env ->
    fun l ->
      let l1 = FStar_TypeChecker_Env.norm_eff_name env l in
      (FStar_Ident.lid_equals l1 FStar_Parser_Const.effect_PURE_lid) ||
        (FStar_Ident.lid_equals l1 FStar_Parser_Const.effect_GHOST_lid)
let (lax_mk_tot_or_comp_l :
  FStar_Ident.lident ->
    FStar_Syntax_Syntax.universe ->
      FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax ->
        FStar_Syntax_Syntax.cflag Prims.list -> FStar_Syntax_Syntax.comp)
  =
  fun mname ->
    fun u_result ->
      fun result ->
        fun flags ->
          let uu____2999 =
            FStar_Ident.lid_equals mname FStar_Parser_Const.effect_Tot_lid in
          if uu____2999
          then
            FStar_Syntax_Syntax.mk_Total' result
              (FStar_Pervasives_Native.Some u_result)
          else mk_comp_l mname u_result result FStar_Syntax_Syntax.tun flags
let (is_function : FStar_Syntax_Syntax.term -> Prims.bool) =
  fun t ->
    let uu____3011 =
      let uu____3012 = FStar_Syntax_Subst.compress t in
      uu____3012.FStar_Syntax_Syntax.n in
    match uu____3011 with
    | FStar_Syntax_Syntax.Tm_arrow uu____3016 -> true
    | uu____3032 -> false
let (label :
  Prims.string ->
    FStar_Range.range -> FStar_Syntax_Syntax.typ -> FStar_Syntax_Syntax.typ)
  =
  fun reason ->
    fun r ->
      fun f ->
        FStar_Syntax_Syntax.mk
          (FStar_Syntax_Syntax.Tm_meta
             (f, (FStar_Syntax_Syntax.Meta_labeled (reason, r, false))))
          f.FStar_Syntax_Syntax.pos
let (label_opt :
  FStar_TypeChecker_Env.env ->
    (unit -> Prims.string) FStar_Pervasives_Native.option ->
      FStar_Range.range -> FStar_Syntax_Syntax.typ -> FStar_Syntax_Syntax.typ)
  =
  fun env ->
    fun reason ->
      fun r ->
        fun f ->
          match reason with
          | FStar_Pervasives_Native.None -> f
          | FStar_Pervasives_Native.Some reason1 ->
              let uu____3102 =
                let uu____3104 = FStar_TypeChecker_Env.should_verify env in
                FStar_All.pipe_left Prims.op_Negation uu____3104 in
              if uu____3102
              then f
              else (let uu____3111 = reason1 () in label uu____3111 r f)
let (label_guard :
  FStar_Range.range ->
    Prims.string ->
      FStar_TypeChecker_Common.guard_t -> FStar_TypeChecker_Common.guard_t)
  =
  fun r ->
    fun reason ->
      fun g ->
        match g.FStar_TypeChecker_Common.guard_f with
        | FStar_TypeChecker_Common.Trivial -> g
        | FStar_TypeChecker_Common.NonTrivial f ->
            let uu___405_3132 = g in
            let uu____3133 =
              let uu____3134 = label reason r f in
              FStar_TypeChecker_Common.NonTrivial uu____3134 in
            {
              FStar_TypeChecker_Common.guard_f = uu____3133;
              FStar_TypeChecker_Common.deferred_to_tac =
                (uu___405_3132.FStar_TypeChecker_Common.deferred_to_tac);
              FStar_TypeChecker_Common.deferred =
                (uu___405_3132.FStar_TypeChecker_Common.deferred);
              FStar_TypeChecker_Common.univ_ineqs =
                (uu___405_3132.FStar_TypeChecker_Common.univ_ineqs);
              FStar_TypeChecker_Common.implicits =
                (uu___405_3132.FStar_TypeChecker_Common.implicits)
            }
let (close_wp_comp :
  FStar_TypeChecker_Env.env ->
    FStar_Syntax_Syntax.bv Prims.list ->
      FStar_Syntax_Syntax.comp -> FStar_Syntax_Syntax.comp)
  =
  fun env ->
    fun bvs ->
      fun c ->
        let uu____3155 = FStar_Syntax_Util.is_ml_comp c in
        if uu____3155
        then c
        else
          (let uu____3160 =
             env.FStar_TypeChecker_Env.lax && (FStar_Options.ml_ish ()) in
           if uu____3160
           then c
           else
             (let close_wp u_res md res_t bvs1 wp0 =
                let close =
                  let uu____3202 =
                    FStar_All.pipe_right md
                      FStar_Syntax_Util.get_wp_close_combinator in
                  FStar_All.pipe_right uu____3202 FStar_Util.must in
                FStar_List.fold_right
                  (fun x ->
                     fun wp ->
                       let bs =
                         let uu____3231 = FStar_Syntax_Syntax.mk_binder x in
                         [uu____3231] in
                       let us =
                         let uu____3253 =
                           let uu____3256 =
                             env.FStar_TypeChecker_Env.universe_of env
                               x.FStar_Syntax_Syntax.sort in
                           [uu____3256] in
                         u_res :: uu____3253 in
                       let wp1 =
                         FStar_Syntax_Util.abs bs wp
                           (FStar_Pervasives_Native.Some
                              (FStar_Syntax_Util.mk_residual_comp
                                 FStar_Parser_Const.effect_Tot_lid
                                 FStar_Pervasives_Native.None
                                 [FStar_Syntax_Syntax.TOTAL])) in
                       let uu____3262 =
                         FStar_TypeChecker_Env.inst_effect_fun_with us env md
                           close in
                       let uu____3263 =
                         let uu____3264 = FStar_Syntax_Syntax.as_arg res_t in
                         let uu____3273 =
                           let uu____3284 =
                             FStar_Syntax_Syntax.as_arg
                               x.FStar_Syntax_Syntax.sort in
                           let uu____3293 =
                             let uu____3304 = FStar_Syntax_Syntax.as_arg wp1 in
                             [uu____3304] in
                           uu____3284 :: uu____3293 in
                         uu____3264 :: uu____3273 in
                       FStar_Syntax_Syntax.mk_Tm_app uu____3262 uu____3263
                         wp0.FStar_Syntax_Syntax.pos) bvs1 wp0 in
              let c1 = FStar_TypeChecker_Env.unfold_effect_abbrev env c in
              let uu____3346 = destruct_wp_comp c1 in
              match uu____3346 with
              | (u_res_t, res_t, wp) ->
                  let md =
                    FStar_TypeChecker_Env.get_effect_decl env
                      c1.FStar_Syntax_Syntax.effect_name in
                  let wp1 = close_wp u_res_t md res_t bvs wp in
                  mk_comp md u_res_t c1.FStar_Syntax_Syntax.result_typ wp1
                    c1.FStar_Syntax_Syntax.flags))
let (close_wp_lcomp :
  FStar_TypeChecker_Env.env ->
    FStar_Syntax_Syntax.bv Prims.list ->
      FStar_TypeChecker_Common.lcomp -> FStar_TypeChecker_Common.lcomp)
  =
  fun env ->
    fun bvs ->
      fun lc ->
        let bs =
          FStar_All.pipe_right bvs
            (FStar_List.map FStar_Syntax_Syntax.mk_binder) in
        FStar_All.pipe_right lc
          (FStar_TypeChecker_Common.apply_lcomp (close_wp_comp env bvs)
             (fun g ->
                let uu____3386 =
                  FStar_All.pipe_right g
                    (FStar_TypeChecker_Env.close_guard env bs) in
                FStar_All.pipe_right uu____3386
                  (close_guard_implicits env false bs)))
let (close_layered_lcomp :
  FStar_TypeChecker_Env.env ->
    FStar_Syntax_Syntax.bv Prims.list ->
      FStar_Syntax_Syntax.term Prims.list ->
        FStar_TypeChecker_Common.lcomp -> FStar_TypeChecker_Common.lcomp)
  =
  fun env ->
    fun bvs ->
      fun tms ->
        fun lc ->
          let bs =
            FStar_All.pipe_right bvs
              (FStar_List.map FStar_Syntax_Syntax.mk_binder) in
          let substs =
            FStar_List.map2
              (fun bv -> fun tm -> FStar_Syntax_Syntax.NT (bv, tm)) bvs tms in
          FStar_All.pipe_right lc
            (FStar_TypeChecker_Common.apply_lcomp
               (FStar_Syntax_Subst.subst_comp substs)
               (fun g ->
                  let uu____3436 =
                    FStar_All.pipe_right g
                      (FStar_TypeChecker_Env.close_guard env bs) in
                  FStar_All.pipe_right uu____3436
                    (close_guard_implicits env false bs)))
let (should_not_inline_lc : FStar_TypeChecker_Common.lcomp -> Prims.bool) =
  fun lc ->
    FStar_All.pipe_right lc.FStar_TypeChecker_Common.cflags
      (FStar_Util.for_some
         (fun uu___0_3449 ->
            match uu___0_3449 with
            | FStar_Syntax_Syntax.SHOULD_NOT_INLINE -> true
            | uu____3452 -> false))
let (should_return :
  FStar_TypeChecker_Env.env ->
    FStar_Syntax_Syntax.term FStar_Pervasives_Native.option ->
      FStar_TypeChecker_Common.lcomp -> Prims.bool)
  =
  fun env ->
    fun eopt ->
      fun lc ->
        let lc_is_unit_or_effectful =
          let uu____3477 =
            let uu____3480 =
              FStar_All.pipe_right lc.FStar_TypeChecker_Common.res_typ
                FStar_Syntax_Util.arrow_formals_comp in
            FStar_All.pipe_right uu____3480 FStar_Pervasives_Native.snd in
          FStar_All.pipe_right uu____3477
            (fun c ->
               (let uu____3504 =
                  FStar_TypeChecker_Env.is_reifiable_comp env c in
                Prims.op_Negation uu____3504) &&
                 ((FStar_All.pipe_right (FStar_Syntax_Util.comp_result c)
                     FStar_Syntax_Util.is_unit)
                    ||
                    (let uu____3508 =
                       FStar_Syntax_Util.is_pure_or_ghost_comp c in
                     Prims.op_Negation uu____3508))) in
        match eopt with
        | FStar_Pervasives_Native.None -> false
        | FStar_Pervasives_Native.Some e ->
            (((FStar_TypeChecker_Common.is_pure_or_ghost_lcomp lc) &&
                (Prims.op_Negation lc_is_unit_or_effectful))
               &&
               (let uu____3519 = FStar_Syntax_Util.head_and_args' e in
                match uu____3519 with
                | (head, uu____3536) ->
                    let uu____3557 =
                      let uu____3558 = FStar_Syntax_Util.un_uinst head in
                      uu____3558.FStar_Syntax_Syntax.n in
                    (match uu____3557 with
                     | FStar_Syntax_Syntax.Tm_fvar fv ->
                         let uu____3563 =
                           let uu____3565 = FStar_Syntax_Syntax.lid_of_fv fv in
                           FStar_TypeChecker_Env.is_irreducible env
                             uu____3565 in
                         Prims.op_Negation uu____3563
                     | uu____3566 -> true)))
              &&
              (let uu____3569 = should_not_inline_lc lc in
               Prims.op_Negation uu____3569)
let (return_value :
  FStar_TypeChecker_Env.env ->
    FStar_Ident.lident ->
      FStar_Syntax_Syntax.universe FStar_Pervasives_Native.option ->
        FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax ->
          FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax ->
            (FStar_Syntax_Syntax.comp * FStar_TypeChecker_Common.guard_t))
  =
  fun env ->
    fun eff_lid ->
      fun u_t_opt ->
        fun t ->
          fun v ->
            let u =
              match u_t_opt with
              | FStar_Pervasives_Native.None ->
                  env.FStar_TypeChecker_Env.universe_of env t
              | FStar_Pervasives_Native.Some u -> u in
            let uu____3615 =
              FStar_TypeChecker_Env.get_effect_decl env eff_lid in
            mk_return env uu____3615 u t v v.FStar_Syntax_Syntax.pos
let (mk_indexed_bind :
  FStar_TypeChecker_Env.env ->
    FStar_Ident.lident ->
      FStar_Ident.lident ->
        FStar_Ident.lident ->
          FStar_Syntax_Syntax.tscheme ->
            FStar_Syntax_Syntax.comp_typ ->
              FStar_Syntax_Syntax.bv FStar_Pervasives_Native.option ->
                FStar_Syntax_Syntax.comp_typ ->
                  FStar_Syntax_Syntax.cflag Prims.list ->
                    FStar_Range.range ->
                      (FStar_Syntax_Syntax.comp *
                        FStar_TypeChecker_Common.guard_t))
  =
  fun env ->
    fun m ->
      fun n ->
        fun p ->
          fun bind_t ->
            fun ct1 ->
              fun b ->
                fun ct2 ->
                  fun flags ->
                    fun r1 ->
                      (let uu____3684 =
                         FStar_All.pipe_left
                           (FStar_TypeChecker_Env.debug env)
                           (FStar_Options.Other "LayeredEffects") in
                       if uu____3684
                       then
                         let uu____3689 =
                           let uu____3691 = FStar_Syntax_Syntax.mk_Comp ct1 in
                           FStar_Syntax_Print.comp_to_string uu____3691 in
                         let uu____3692 =
                           let uu____3694 = FStar_Syntax_Syntax.mk_Comp ct2 in
                           FStar_Syntax_Print.comp_to_string uu____3694 in
                         FStar_Util.print2 "Binding c1:%s and c2:%s {\n"
                           uu____3689 uu____3692
                       else ());
                      (let uu____3699 =
                         FStar_All.pipe_left
                           (FStar_TypeChecker_Env.debug env)
                           (FStar_Options.Other "ResolveImplicitsHook") in
                       if uu____3699
                       then
                         let uu____3704 =
                           let uu____3706 =
                             FStar_TypeChecker_Env.get_range env in
                           FStar_Range.string_of_range uu____3706 in
                         let uu____3707 =
                           FStar_Syntax_Print.tscheme_to_string bind_t in
                         FStar_Util.print2
                           "///////////////////////////////Bind at %s/////////////////////\nwith bind_t = %s\n"
                           uu____3704 uu____3707
                       else ());
                      (let uu____3712 =
                         let uu____3719 =
                           FStar_TypeChecker_Env.get_effect_decl env m in
                         let uu____3720 =
                           FStar_TypeChecker_Env.get_effect_decl env n in
                         let uu____3721 =
                           FStar_TypeChecker_Env.get_effect_decl env p in
                         (uu____3719, uu____3720, uu____3721) in
                       match uu____3712 with
                       | (m_ed, n_ed, p_ed) ->
                           let uu____3729 =
                             let uu____3742 =
                               FStar_List.hd
                                 ct1.FStar_Syntax_Syntax.comp_univs in
                             let uu____3743 =
                               FStar_List.map FStar_Pervasives_Native.fst
                                 ct1.FStar_Syntax_Syntax.effect_args in
                             (uu____3742,
                               (ct1.FStar_Syntax_Syntax.result_typ),
                               uu____3743) in
                           (match uu____3729 with
                            | (u1, t1, is1) ->
                                let uu____3787 =
                                  let uu____3800 =
                                    FStar_List.hd
                                      ct2.FStar_Syntax_Syntax.comp_univs in
                                  let uu____3801 =
                                    FStar_List.map
                                      FStar_Pervasives_Native.fst
                                      ct2.FStar_Syntax_Syntax.effect_args in
                                  (uu____3800,
                                    (ct2.FStar_Syntax_Syntax.result_typ),
                                    uu____3801) in
                                (match uu____3787 with
                                 | (u2, t2, is2) ->
                                     let uu____3845 =
                                       FStar_TypeChecker_Env.inst_tscheme_with
                                         bind_t [u1; u2] in
                                     (match uu____3845 with
                                      | (uu____3854, bind_t1) ->
                                          let bind_t_shape_error s =
                                            let uu____3869 =
                                              let uu____3871 =
                                                FStar_Syntax_Print.term_to_string
                                                  bind_t1 in
                                              FStar_Util.format2
                                                "bind %s does not have proper shape (reason:%s)"
                                                uu____3871 s in
                                            (FStar_Errors.Fatal_UnexpectedEffect,
                                              uu____3869) in
                                          let uu____3875 =
                                            let uu____3920 =
                                              let uu____3921 =
                                                FStar_Syntax_Subst.compress
                                                  bind_t1 in
                                              uu____3921.FStar_Syntax_Syntax.n in
                                            match uu____3920 with
                                            | FStar_Syntax_Syntax.Tm_arrow
                                                (bs, c) when
                                                (FStar_List.length bs) >=
                                                  (Prims.of_int (4))
                                                ->
                                                let uu____3997 =
                                                  FStar_Syntax_Subst.open_comp
                                                    bs c in
                                                (match uu____3997 with
                                                 | (a_b::b_b::bs1, c1) ->
                                                     let uu____4082 =
                                                       let uu____4109 =
                                                         FStar_List.splitAt
                                                           ((FStar_List.length
                                                               bs1)
                                                              -
                                                              (Prims.of_int (2)))
                                                           bs1 in
                                                       FStar_All.pipe_right
                                                         uu____4109
                                                         (fun uu____4194 ->
                                                            match uu____4194
                                                            with
                                                            | (l1, l2) ->
                                                                let uu____4275
                                                                  =
                                                                  FStar_List.hd
                                                                    l2 in
                                                                let uu____4288
                                                                  =
                                                                  let uu____4295
                                                                    =
                                                                    FStar_List.tl
                                                                    l2 in
                                                                  FStar_List.hd
                                                                    uu____4295 in
                                                                (l1,
                                                                  uu____4275,
                                                                  uu____4288)) in
                                                     (match uu____4082 with
                                                      | (rest_bs, f_b, g_b)
                                                          ->
                                                          (a_b, b_b, rest_bs,
                                                            f_b, g_b, c1)))
                                            | uu____4455 ->
                                                let uu____4456 =
                                                  bind_t_shape_error
                                                    "Either not an arrow or not enough binders" in
                                                FStar_Errors.raise_error
                                                  uu____4456 r1 in
                                          (match uu____3875 with
                                           | (a_b, b_b, rest_bs, f_b, g_b,
                                              bind_c) ->
                                               let uu____4581 =
                                                 let uu____4588 =
                                                   let uu____4589 =
                                                     let uu____4590 =
                                                       let uu____4597 =
                                                         FStar_All.pipe_right
                                                           a_b
                                                           FStar_Pervasives_Native.fst in
                                                       (uu____4597, t1) in
                                                     FStar_Syntax_Syntax.NT
                                                       uu____4590 in
                                                   let uu____4608 =
                                                     let uu____4611 =
                                                       let uu____4612 =
                                                         let uu____4619 =
                                                           FStar_All.pipe_right
                                                             b_b
                                                             FStar_Pervasives_Native.fst in
                                                         (uu____4619, t2) in
                                                       FStar_Syntax_Syntax.NT
                                                         uu____4612 in
                                                     [uu____4611] in
                                                   uu____4589 :: uu____4608 in
                                                 FStar_TypeChecker_Env.uvars_for_binders
                                                   env rest_bs uu____4588
                                                   (fun b1 ->
                                                      let uu____4635 =
                                                        FStar_Syntax_Print.binder_to_string
                                                          b1 in
                                                      let uu____4637 =
                                                        let uu____4639 =
                                                          FStar_Ident.string_of_lid
                                                            m in
                                                        let uu____4641 =
                                                          FStar_Ident.string_of_lid
                                                            n in
                                                        let uu____4643 =
                                                          FStar_Ident.string_of_lid
                                                            p in
                                                        FStar_Util.format3
                                                          "(%s, %s) |> %s"
                                                          uu____4639
                                                          uu____4641
                                                          uu____4643 in
                                                      let uu____4646 =
                                                        FStar_Range.string_of_range
                                                          r1 in
                                                      FStar_Util.format3
                                                        "implicit var for binder %s of %s at %s"
                                                        uu____4635 uu____4637
                                                        uu____4646) r1 in
                                               (match uu____4581 with
                                                | (rest_bs_uvars, g_uvars) ->
                                                    ((let uu____4660 =
                                                        FStar_All.pipe_left
                                                          (FStar_TypeChecker_Env.debug
                                                             env)
                                                          (FStar_Options.Other
                                                             "ResolveImplicitsHook") in
                                                      if uu____4660
                                                      then
                                                        FStar_All.pipe_right
                                                          rest_bs_uvars
                                                          (FStar_List.iter
                                                             (fun t ->
                                                                let uu____4674
                                                                  =
                                                                  let uu____4675
                                                                    =
                                                                    FStar_Syntax_Subst.compress
                                                                    t in
                                                                  uu____4675.FStar_Syntax_Syntax.n in
                                                                match uu____4674
                                                                with
                                                                | FStar_Syntax_Syntax.Tm_uvar
                                                                    (u,
                                                                    uu____4679)
                                                                    ->
                                                                    let uu____4696
                                                                    =
                                                                    FStar_Syntax_Print.term_to_string
                                                                    t in
                                                                    let uu____4698
                                                                    =
                                                                    match 
                                                                    u.FStar_Syntax_Syntax.ctx_uvar_meta
                                                                    with
                                                                    | 
                                                                    FStar_Pervasives_Native.Some
                                                                    (FStar_Syntax_Syntax.Ctx_uvar_meta_attr
                                                                    a) ->
                                                                    FStar_Syntax_Print.term_to_string
                                                                    a
                                                                    | 
                                                                    uu____4704
                                                                    ->
                                                                    "<no attr>" in
                                                                    FStar_Util.print2
                                                                    "Generated uvar %s with attribute %s\n"
                                                                    uu____4696
                                                                    uu____4698))
                                                      else ());
                                                     (let subst =
                                                        FStar_List.map2
                                                          (fun b1 ->
                                                             fun t ->
                                                               let uu____4735
                                                                 =
                                                                 let uu____4742
                                                                   =
                                                                   FStar_All.pipe_right
                                                                    b1
                                                                    FStar_Pervasives_Native.fst in
                                                                 (uu____4742,
                                                                   t) in
                                                               FStar_Syntax_Syntax.NT
                                                                 uu____4735)
                                                          (a_b :: b_b ::
                                                          rest_bs) (t1 :: t2
                                                          :: rest_bs_uvars) in
                                                      let f_guard =
                                                        let f_sort_is =
                                                          let uu____4771 =
                                                            let uu____4774 =
                                                              let uu____4775
                                                                =
                                                                let uu____4776
                                                                  =
                                                                  FStar_All.pipe_right
                                                                    f_b
                                                                    FStar_Pervasives_Native.fst in
                                                                uu____4776.FStar_Syntax_Syntax.sort in
                                                              FStar_Syntax_Subst.compress
                                                                uu____4775 in
                                                            let uu____4785 =
                                                              FStar_Syntax_Util.is_layered
                                                                m_ed in
                                                            effect_args_from_repr
                                                              uu____4774
                                                              uu____4785 r1 in
                                                          FStar_All.pipe_right
                                                            uu____4771
                                                            (FStar_List.map
                                                               (FStar_Syntax_Subst.subst
                                                                  subst)) in
                                                        FStar_List.fold_left2
                                                          (fun g ->
                                                             fun i1 ->
                                                               fun f_i1 ->
                                                                 (let uu____4810
                                                                    =
                                                                    FStar_All.pipe_left
                                                                    (FStar_TypeChecker_Env.debug
                                                                    env)
                                                                    (FStar_Options.Other
                                                                    "ResolveImplicitsHook") in
                                                                  if
                                                                    uu____4810
                                                                  then
                                                                    let uu____4815
                                                                    =
                                                                    FStar_Syntax_Print.term_to_string
                                                                    i1 in
                                                                    let uu____4817
                                                                    =
                                                                    FStar_Syntax_Print.term_to_string
                                                                    f_i1 in
                                                                    FStar_Util.print2
                                                                    "Generating constraint %s = %s\n"
                                                                    uu____4815
                                                                    uu____4817
                                                                  else ());
                                                                 (let uu____4822
                                                                    =
                                                                    FStar_TypeChecker_Rel.teq
                                                                    env i1
                                                                    f_i1 in
                                                                  FStar_TypeChecker_Env.conj_guard
                                                                    g
                                                                    uu____4822))
                                                          FStar_TypeChecker_Env.trivial_guard
                                                          is1 f_sort_is in
                                                      let g_guard =
                                                        let x_a =
                                                          match b with
                                                          | FStar_Pervasives_Native.None
                                                              ->
                                                              FStar_Syntax_Syntax.null_binder
                                                                ct1.FStar_Syntax_Syntax.result_typ
                                                          | FStar_Pervasives_Native.Some
                                                              x ->
                                                              FStar_Syntax_Syntax.mk_binder
                                                                x in
                                                        let g_sort_is =
                                                          let uu____4841 =
                                                            let uu____4842 =
                                                              let uu____4845
                                                                =
                                                                let uu____4846
                                                                  =
                                                                  FStar_All.pipe_right
                                                                    g_b
                                                                    FStar_Pervasives_Native.fst in
                                                                uu____4846.FStar_Syntax_Syntax.sort in
                                                              FStar_Syntax_Subst.compress
                                                                uu____4845 in
                                                            uu____4842.FStar_Syntax_Syntax.n in
                                                          match uu____4841
                                                          with
                                                          | FStar_Syntax_Syntax.Tm_arrow
                                                              (bs, c) ->
                                                              let uu____4879
                                                                =
                                                                FStar_Syntax_Subst.open_comp
                                                                  bs c in
                                                              (match uu____4879
                                                               with
                                                               | (bs1, c1) ->
                                                                   let bs_subst
                                                                    =
                                                                    let uu____4889
                                                                    =
                                                                    let uu____4896
                                                                    =
                                                                    let uu____4897
                                                                    =
                                                                    FStar_List.hd
                                                                    bs1 in
                                                                    FStar_All.pipe_right
                                                                    uu____4897
                                                                    FStar_Pervasives_Native.fst in
                                                                    let uu____4918
                                                                    =
                                                                    let uu____4921
                                                                    =
                                                                    FStar_All.pipe_right
                                                                    x_a
                                                                    FStar_Pervasives_Native.fst in
                                                                    FStar_All.pipe_right
                                                                    uu____4921
                                                                    FStar_Syntax_Syntax.bv_to_name in
                                                                    (uu____4896,
                                                                    uu____4918) in
                                                                    FStar_Syntax_Syntax.NT
                                                                    uu____4889 in
                                                                   let c2 =
                                                                    FStar_Syntax_Subst.subst_comp
                                                                    [bs_subst]
                                                                    c1 in
                                                                   let uu____4935
                                                                    =
                                                                    let uu____4938
                                                                    =
                                                                    FStar_Syntax_Subst.compress
                                                                    (FStar_Syntax_Util.comp_result
                                                                    c2) in
                                                                    let uu____4939
                                                                    =
                                                                    FStar_Syntax_Util.is_layered
                                                                    n_ed in
                                                                    effect_args_from_repr
                                                                    uu____4938
                                                                    uu____4939
                                                                    r1 in
                                                                   FStar_All.pipe_right
                                                                    uu____4935
                                                                    (FStar_List.map
                                                                    (FStar_Syntax_Subst.subst
                                                                    subst)))
                                                          | uu____4945 ->
                                                              failwith
                                                                "imspossible: mk_indexed_bind" in
                                                        let env_g =
                                                          FStar_TypeChecker_Env.push_binders
                                                            env [x_a] in
                                                        let uu____4962 =
                                                          FStar_List.fold_left2
                                                            (fun g ->
                                                               fun i1 ->
                                                                 fun g_i1 ->
                                                                   (let uu____4980
                                                                    =
                                                                    FStar_All.pipe_left
                                                                    (FStar_TypeChecker_Env.debug
                                                                    env)
                                                                    (FStar_Options.Other
                                                                    "ResolveImplicitsHook") in
                                                                    if
                                                                    uu____4980
                                                                    then
                                                                    let uu____4985
                                                                    =
                                                                    FStar_Syntax_Print.term_to_string
                                                                    i1 in
                                                                    let uu____4987
                                                                    =
                                                                    FStar_Syntax_Print.term_to_string
                                                                    g_i1 in
                                                                    FStar_Util.print2
                                                                    "Generating constraint %s = %s\n"
                                                                    uu____4985
                                                                    uu____4987
                                                                    else ());
                                                                   (let uu____4992
                                                                    =
                                                                    FStar_TypeChecker_Rel.teq
                                                                    env_g i1
                                                                    g_i1 in
                                                                    FStar_TypeChecker_Env.conj_guard
                                                                    g
                                                                    uu____4992))
                                                            FStar_TypeChecker_Env.trivial_guard
                                                            is2 g_sort_is in
                                                        FStar_All.pipe_right
                                                          uu____4962
                                                          (FStar_TypeChecker_Env.close_guard
                                                             env [x_a]) in
                                                      let bind_ct =
                                                        let uu____5006 =
                                                          FStar_All.pipe_right
                                                            bind_c
                                                            (FStar_Syntax_Subst.subst_comp
                                                               subst) in
                                                        FStar_All.pipe_right
                                                          uu____5006
                                                          FStar_Syntax_Util.comp_to_comp_typ in
                                                      let fml =
                                                        let uu____5008 =
                                                          let uu____5013 =
                                                            FStar_List.hd
                                                              bind_ct.FStar_Syntax_Syntax.comp_univs in
                                                          let uu____5014 =
                                                            let uu____5015 =
                                                              FStar_List.hd
                                                                bind_ct.FStar_Syntax_Syntax.effect_args in
                                                            FStar_Pervasives_Native.fst
                                                              uu____5015 in
                                                          (uu____5013,
                                                            uu____5014) in
                                                        match uu____5008 with
                                                        | (u, wp) ->
                                                            FStar_TypeChecker_Env.pure_precondition_for_trivial_post
                                                              env u
                                                              bind_ct.FStar_Syntax_Syntax.result_typ
                                                              wp
                                                              FStar_Range.dummyRange in
                                                      let is =
                                                        let uu____5041 =
                                                          FStar_Syntax_Subst.compress
                                                            bind_ct.FStar_Syntax_Syntax.result_typ in
                                                        let uu____5042 =
                                                          FStar_Syntax_Util.is_layered
                                                            p_ed in
                                                        effect_args_from_repr
                                                          uu____5041
                                                          uu____5042 r1 in
                                                      let c =
                                                        let uu____5045 =
                                                          let uu____5046 =
                                                            FStar_List.map
                                                              FStar_Syntax_Syntax.as_arg
                                                              is in
                                                          {
                                                            FStar_Syntax_Syntax.comp_univs
                                                              =
                                                              (ct2.FStar_Syntax_Syntax.comp_univs);
                                                            FStar_Syntax_Syntax.effect_name
                                                              =
                                                              (p_ed.FStar_Syntax_Syntax.mname);
                                                            FStar_Syntax_Syntax.result_typ
                                                              = t2;
                                                            FStar_Syntax_Syntax.effect_args
                                                              = uu____5046;
                                                            FStar_Syntax_Syntax.flags
                                                              = flags
                                                          } in
                                                        FStar_Syntax_Syntax.mk_Comp
                                                          uu____5045 in
                                                      (let uu____5066 =
                                                         FStar_All.pipe_left
                                                           (FStar_TypeChecker_Env.debug
                                                              env)
                                                           (FStar_Options.Other
                                                              "LayeredEffects") in
                                                       if uu____5066
                                                       then
                                                         let uu____5071 =
                                                           FStar_Syntax_Print.comp_to_string
                                                             c in
                                                         FStar_Util.print1
                                                           "} c after bind: %s\n"
                                                           uu____5071
                                                       else ());
                                                      (let guard =
                                                         let uu____5077 =
                                                           let uu____5080 =
                                                             let uu____5083 =
                                                               let uu____5086
                                                                 =
                                                                 let uu____5089
                                                                   =
                                                                   FStar_TypeChecker_Env.guard_of_guard_formula
                                                                    (FStar_TypeChecker_Common.NonTrivial
                                                                    fml) in
                                                                 [uu____5089] in
                                                               g_guard ::
                                                                 uu____5086 in
                                                             f_guard ::
                                                               uu____5083 in
                                                           g_uvars ::
                                                             uu____5080 in
                                                         FStar_TypeChecker_Env.conj_guards
                                                           uu____5077 in
                                                       (let uu____5091 =
                                                          FStar_All.pipe_left
                                                            (FStar_TypeChecker_Env.debug
                                                               env)
                                                            (FStar_Options.Other
                                                               "ResolveImplicitsHook") in
                                                        if uu____5091
                                                        then
                                                          let uu____5096 =
                                                            let uu____5098 =
                                                              FStar_TypeChecker_Env.get_range
                                                                env in
                                                            FStar_Range.string_of_range
                                                              uu____5098 in
                                                          let uu____5099 =
                                                            FStar_TypeChecker_Rel.guard_to_string
                                                              env guard in
                                                          FStar_Util.print2
                                                            "///////////////////////////////EndBind at %s/////////////////////\nguard = %s\n"
                                                            uu____5096
                                                            uu____5099
                                                        else ());
                                                       (c, guard))))))))))
let (mk_wp_bind :
  FStar_TypeChecker_Env.env ->
    FStar_Ident.lident ->
      FStar_Syntax_Syntax.comp_typ ->
        FStar_Syntax_Syntax.bv FStar_Pervasives_Native.option ->
          FStar_Syntax_Syntax.comp_typ ->
            FStar_Syntax_Syntax.cflag Prims.list ->
              FStar_Range.range -> FStar_Syntax_Syntax.comp)
  =
  fun env ->
    fun m ->
      fun ct1 ->
        fun b ->
          fun ct2 ->
            fun flags ->
              fun r1 ->
                let uu____5148 =
                  let md = FStar_TypeChecker_Env.get_effect_decl env m in
                  let uu____5174 = FStar_TypeChecker_Env.wp_signature env m in
                  match uu____5174 with
                  | (a, kwp) ->
                      let uu____5205 = destruct_wp_comp ct1 in
                      let uu____5212 = destruct_wp_comp ct2 in
                      ((md, a, kwp), uu____5205, uu____5212) in
                match uu____5148 with
                | ((md, a, kwp), (u_t1, t1, wp1), (u_t2, t2, wp2)) ->
                    let bs =
                      match b with
                      | FStar_Pervasives_Native.None ->
                          let uu____5265 = FStar_Syntax_Syntax.null_binder t1 in
                          [uu____5265]
                      | FStar_Pervasives_Native.Some x ->
                          let uu____5285 = FStar_Syntax_Syntax.mk_binder x in
                          [uu____5285] in
                    let mk_lam wp =
                      FStar_Syntax_Util.abs bs wp
                        (FStar_Pervasives_Native.Some
                           (FStar_Syntax_Util.mk_residual_comp
                              FStar_Parser_Const.effect_Tot_lid
                              FStar_Pervasives_Native.None
                              [FStar_Syntax_Syntax.TOTAL])) in
                    let r11 =
                      FStar_Syntax_Syntax.mk
                        (FStar_Syntax_Syntax.Tm_constant
                           (FStar_Const.Const_range r1)) r1 in
                    let wp_args =
                      let uu____5332 = FStar_Syntax_Syntax.as_arg r11 in
                      let uu____5341 =
                        let uu____5352 = FStar_Syntax_Syntax.as_arg t1 in
                        let uu____5361 =
                          let uu____5372 = FStar_Syntax_Syntax.as_arg t2 in
                          let uu____5381 =
                            let uu____5392 = FStar_Syntax_Syntax.as_arg wp1 in
                            let uu____5401 =
                              let uu____5412 =
                                let uu____5421 = mk_lam wp2 in
                                FStar_Syntax_Syntax.as_arg uu____5421 in
                              [uu____5412] in
                            uu____5392 :: uu____5401 in
                          uu____5372 :: uu____5381 in
                        uu____5352 :: uu____5361 in
                      uu____5332 :: uu____5341 in
                    let bind_wp =
                      FStar_All.pipe_right md
                        FStar_Syntax_Util.get_bind_vc_combinator in
                    let wp =
                      let uu____5472 =
                        FStar_TypeChecker_Env.inst_effect_fun_with
                          [u_t1; u_t2] env md bind_wp in
                      FStar_Syntax_Syntax.mk_Tm_app uu____5472 wp_args
                        t2.FStar_Syntax_Syntax.pos in
                    mk_comp md u_t2 t2 wp flags
let (mk_bind :
  FStar_TypeChecker_Env.env ->
    FStar_Syntax_Syntax.comp ->
      FStar_Syntax_Syntax.bv FStar_Pervasives_Native.option ->
        FStar_Syntax_Syntax.comp ->
          FStar_Syntax_Syntax.cflag Prims.list ->
            FStar_Range.range ->
              (FStar_Syntax_Syntax.comp * FStar_TypeChecker_Common.guard_t))
  =
  fun env ->
    fun c1 ->
      fun b ->
        fun c2 ->
          fun flags ->
            fun r1 ->
              let uu____5520 =
                let uu____5525 =
                  FStar_TypeChecker_Env.unfold_effect_abbrev env c1 in
                let uu____5526 =
                  FStar_TypeChecker_Env.unfold_effect_abbrev env c2 in
                (uu____5525, uu____5526) in
              match uu____5520 with
              | (ct1, ct2) ->
                  let uu____5533 =
                    FStar_TypeChecker_Env.exists_polymonadic_bind env
                      ct1.FStar_Syntax_Syntax.effect_name
                      ct2.FStar_Syntax_Syntax.effect_name in
                  (match uu____5533 with
                   | FStar_Pervasives_Native.Some (p, f_bind) ->
                       f_bind env ct1 b ct2 flags r1
                   | FStar_Pervasives_Native.None ->
                       let uu____5584 = lift_comps env c1 c2 b true in
                       (match uu____5584 with
                        | (m, c11, c21, g_lift) ->
                            let uu____5602 =
                              let uu____5607 =
                                FStar_Syntax_Util.comp_to_comp_typ c11 in
                              let uu____5608 =
                                FStar_Syntax_Util.comp_to_comp_typ c21 in
                              (uu____5607, uu____5608) in
                            (match uu____5602 with
                             | (ct11, ct21) ->
                                 let uu____5615 =
                                   let uu____5620 =
                                     FStar_TypeChecker_Env.is_layered_effect
                                       env m in
                                   if uu____5620
                                   then
                                     let bind_t =
                                       let uu____5628 =
                                         FStar_All.pipe_right m
                                           (FStar_TypeChecker_Env.get_effect_decl
                                              env) in
                                       FStar_All.pipe_right uu____5628
                                         FStar_Syntax_Util.get_bind_vc_combinator in
                                     mk_indexed_bind env m m m bind_t ct11 b
                                       ct21 flags r1
                                   else
                                     (let uu____5631 =
                                        mk_wp_bind env m ct11 b ct21 flags r1 in
                                      (uu____5631,
                                        FStar_TypeChecker_Env.trivial_guard)) in
                                 (match uu____5615 with
                                  | (c, g_bind) ->
                                      let uu____5638 =
                                        FStar_TypeChecker_Env.conj_guard
                                          g_lift g_bind in
                                      (c, uu____5638)))))
let (bind_pure_wp_with :
  FStar_TypeChecker_Env.env ->
    FStar_Syntax_Syntax.typ ->
      FStar_Syntax_Syntax.comp ->
        FStar_Syntax_Syntax.cflag Prims.list ->
          (FStar_Syntax_Syntax.comp * FStar_TypeChecker_Common.guard_t))
  =
  fun env ->
    fun wp1 ->
      fun c ->
        fun flags ->
          let r = FStar_TypeChecker_Env.get_range env in
          let pure_c =
            let uu____5674 =
              let uu____5675 =
                let uu____5686 =
                  FStar_All.pipe_right wp1 FStar_Syntax_Syntax.as_arg in
                [uu____5686] in
              {
                FStar_Syntax_Syntax.comp_univs = [FStar_Syntax_Syntax.U_zero];
                FStar_Syntax_Syntax.effect_name =
                  FStar_Parser_Const.effect_PURE_lid;
                FStar_Syntax_Syntax.result_typ = FStar_Syntax_Syntax.t_unit;
                FStar_Syntax_Syntax.effect_args = uu____5675;
                FStar_Syntax_Syntax.flags = []
              } in
            FStar_Syntax_Syntax.mk_Comp uu____5674 in
          mk_bind env pure_c FStar_Pervasives_Native.None c flags r
let (weaken_flags :
  FStar_Syntax_Syntax.cflag Prims.list ->
    FStar_Syntax_Syntax.cflag Prims.list)
  =
  fun flags ->
    let uu____5731 =
      FStar_All.pipe_right flags
        (FStar_Util.for_some
           (fun uu___1_5737 ->
              match uu___1_5737 with
              | FStar_Syntax_Syntax.SHOULD_NOT_INLINE -> true
              | uu____5740 -> false)) in
    if uu____5731
    then [FStar_Syntax_Syntax.SHOULD_NOT_INLINE]
    else
      FStar_All.pipe_right flags
        (FStar_List.collect
           (fun uu___2_5752 ->
              match uu___2_5752 with
              | FStar_Syntax_Syntax.TOTAL ->
                  [FStar_Syntax_Syntax.TRIVIAL_POSTCONDITION]
              | FStar_Syntax_Syntax.RETURN ->
                  [FStar_Syntax_Syntax.PARTIAL_RETURN;
                  FStar_Syntax_Syntax.TRIVIAL_POSTCONDITION]
              | f -> [f]))
let (weaken_comp :
  FStar_TypeChecker_Env.env ->
    FStar_Syntax_Syntax.comp ->
      FStar_Syntax_Syntax.term ->
        (FStar_Syntax_Syntax.comp * FStar_TypeChecker_Common.guard_t))
  =
  fun env ->
    fun c ->
      fun formula ->
        let uu____5780 = FStar_Syntax_Util.is_ml_comp c in
        if uu____5780
        then (c, FStar_TypeChecker_Env.trivial_guard)
        else
          (let ct = FStar_TypeChecker_Env.unfold_effect_abbrev env c in
           let pure_assume_wp =
             let uu____5791 =
               FStar_Syntax_Syntax.lid_as_fv
                 FStar_Parser_Const.pure_assume_wp_lid
                 (FStar_Syntax_Syntax.Delta_constant_at_level Prims.int_one)
                 FStar_Pervasives_Native.None in
             FStar_Syntax_Syntax.fv_to_tm uu____5791 in
           let pure_assume_wp1 =
             let uu____5794 =
               let uu____5795 =
                 FStar_All.pipe_left FStar_Syntax_Syntax.as_arg formula in
               [uu____5795] in
             let uu____5828 = FStar_TypeChecker_Env.get_range env in
             FStar_Syntax_Syntax.mk_Tm_app pure_assume_wp uu____5794
               uu____5828 in
           let uu____5829 = weaken_flags ct.FStar_Syntax_Syntax.flags in
           bind_pure_wp_with env pure_assume_wp1 c uu____5829)
let (weaken_precondition :
  FStar_TypeChecker_Env.env ->
    FStar_TypeChecker_Common.lcomp ->
      FStar_TypeChecker_Common.guard_formula ->
        FStar_TypeChecker_Common.lcomp)
  =
  fun env ->
    fun lc ->
      fun f ->
        let weaken uu____5857 =
          let uu____5858 = FStar_TypeChecker_Common.lcomp_comp lc in
          match uu____5858 with
          | (c, g_c) ->
              let uu____5869 =
                env.FStar_TypeChecker_Env.lax && (FStar_Options.ml_ish ()) in
              if uu____5869
              then (c, g_c)
              else
                (match f with
                 | FStar_TypeChecker_Common.Trivial -> (c, g_c)
                 | FStar_TypeChecker_Common.NonTrivial f1 ->
                     let uu____5883 = weaken_comp env c f1 in
                     (match uu____5883 with
                      | (c1, g_w) ->
                          let uu____5894 =
                            FStar_TypeChecker_Env.conj_guard g_c g_w in
                          (c1, uu____5894))) in
        let uu____5895 = weaken_flags lc.FStar_TypeChecker_Common.cflags in
        FStar_TypeChecker_Common.mk_lcomp
          lc.FStar_TypeChecker_Common.eff_name
          lc.FStar_TypeChecker_Common.res_typ uu____5895 weaken
let (strengthen_comp :
  FStar_TypeChecker_Env.env ->
    (unit -> Prims.string) FStar_Pervasives_Native.option ->
      FStar_Syntax_Syntax.comp ->
        FStar_Syntax_Syntax.formula ->
          FStar_Syntax_Syntax.cflag Prims.list ->
            (FStar_Syntax_Syntax.comp * FStar_TypeChecker_Common.guard_t))
  =
  fun env ->
    fun reason ->
      fun c ->
        fun f ->
          fun flags ->
            if env.FStar_TypeChecker_Env.lax
            then (c, FStar_TypeChecker_Env.trivial_guard)
            else
              (let r = FStar_TypeChecker_Env.get_range env in
               let pure_assert_wp =
                 let uu____5952 =
                   FStar_Syntax_Syntax.lid_as_fv
                     FStar_Parser_Const.pure_assert_wp_lid
                     (FStar_Syntax_Syntax.Delta_constant_at_level
                        Prims.int_one) FStar_Pervasives_Native.None in
                 FStar_Syntax_Syntax.fv_to_tm uu____5952 in
               let pure_assert_wp1 =
                 let uu____5955 =
                   let uu____5956 =
                     let uu____5965 = label_opt env reason r f in
                     FStar_All.pipe_left FStar_Syntax_Syntax.as_arg
                       uu____5965 in
                   [uu____5956] in
                 FStar_Syntax_Syntax.mk_Tm_app pure_assert_wp uu____5955 r in
               bind_pure_wp_with env pure_assert_wp1 c flags)
let (strengthen_precondition :
  (unit -> Prims.string) FStar_Pervasives_Native.option ->
    FStar_TypeChecker_Env.env ->
      FStar_Syntax_Syntax.term ->
        FStar_TypeChecker_Common.lcomp ->
          FStar_TypeChecker_Common.guard_t ->
            (FStar_TypeChecker_Common.lcomp *
              FStar_TypeChecker_Common.guard_t))
  =
  fun reason ->
    fun env ->
      fun e_for_debugging_only ->
        fun lc ->
          fun g0 ->
            let uu____6035 =
              FStar_TypeChecker_Env.is_trivial_guard_formula g0 in
            if uu____6035
            then (lc, g0)
            else
              (let flags =
                 let uu____6047 =
                   let uu____6055 =
                     FStar_TypeChecker_Common.is_tot_or_gtot_lcomp lc in
                   if uu____6055
                   then (true, [FStar_Syntax_Syntax.TRIVIAL_POSTCONDITION])
                   else (false, []) in
                 match uu____6047 with
                 | (maybe_trivial_post, flags) ->
                     let uu____6085 =
                       FStar_All.pipe_right
                         lc.FStar_TypeChecker_Common.cflags
                         (FStar_List.collect
                            (fun uu___3_6093 ->
                               match uu___3_6093 with
                               | FStar_Syntax_Syntax.RETURN ->
                                   [FStar_Syntax_Syntax.PARTIAL_RETURN]
                               | FStar_Syntax_Syntax.PARTIAL_RETURN ->
                                   [FStar_Syntax_Syntax.PARTIAL_RETURN]
                               | FStar_Syntax_Syntax.SOMETRIVIAL when
                                   Prims.op_Negation maybe_trivial_post ->
                                   [FStar_Syntax_Syntax.TRIVIAL_POSTCONDITION]
                               | FStar_Syntax_Syntax.TRIVIAL_POSTCONDITION
                                   when Prims.op_Negation maybe_trivial_post
                                   ->
                                   [FStar_Syntax_Syntax.TRIVIAL_POSTCONDITION]
                               | FStar_Syntax_Syntax.SHOULD_NOT_INLINE ->
                                   [FStar_Syntax_Syntax.SHOULD_NOT_INLINE]
                               | uu____6096 -> [])) in
                     FStar_List.append flags uu____6085 in
               let strengthen uu____6106 =
                 let uu____6107 = FStar_TypeChecker_Common.lcomp_comp lc in
                 match uu____6107 with
                 | (c, g_c) ->
                     if env.FStar_TypeChecker_Env.lax
                     then (c, g_c)
                     else
                       (let g01 = FStar_TypeChecker_Rel.simplify_guard env g0 in
                        let uu____6126 = FStar_TypeChecker_Env.guard_form g01 in
                        match uu____6126 with
                        | FStar_TypeChecker_Common.Trivial -> (c, g_c)
                        | FStar_TypeChecker_Common.NonTrivial f ->
                            ((let uu____6133 =
                                FStar_All.pipe_left
                                  (FStar_TypeChecker_Env.debug env)
                                  FStar_Options.Extreme in
                              if uu____6133
                              then
                                let uu____6137 =
                                  FStar_TypeChecker_Normalize.term_to_string
                                    env e_for_debugging_only in
                                let uu____6139 =
                                  FStar_TypeChecker_Normalize.term_to_string
                                    env f in
                                FStar_Util.print2
                                  "-------------Strengthening pre-condition of term %s with guard %s\n"
                                  uu____6137 uu____6139
                              else ());
                             (let uu____6144 =
                                strengthen_comp env reason c f flags in
                              match uu____6144 with
                              | (c1, g_s) ->
                                  let uu____6155 =
                                    FStar_TypeChecker_Env.conj_guard g_c g_s in
                                  (c1, uu____6155)))) in
               let uu____6156 =
                 let uu____6157 =
                   FStar_TypeChecker_Env.norm_eff_name env
                     lc.FStar_TypeChecker_Common.eff_name in
                 FStar_TypeChecker_Common.mk_lcomp uu____6157
                   lc.FStar_TypeChecker_Common.res_typ flags strengthen in
               (uu____6156,
                 (let uu___728_6159 = g0 in
                  {
                    FStar_TypeChecker_Common.guard_f =
                      FStar_TypeChecker_Common.Trivial;
                    FStar_TypeChecker_Common.deferred_to_tac =
                      (uu___728_6159.FStar_TypeChecker_Common.deferred_to_tac);
                    FStar_TypeChecker_Common.deferred =
                      (uu___728_6159.FStar_TypeChecker_Common.deferred);
                    FStar_TypeChecker_Common.univ_ineqs =
                      (uu___728_6159.FStar_TypeChecker_Common.univ_ineqs);
                    FStar_TypeChecker_Common.implicits =
                      (uu___728_6159.FStar_TypeChecker_Common.implicits)
                  })))
let (lcomp_has_trivial_postcondition :
  FStar_TypeChecker_Common.lcomp -> Prims.bool) =
  fun lc ->
    (FStar_TypeChecker_Common.is_tot_or_gtot_lcomp lc) ||
      (FStar_Util.for_some
         (fun uu___4_6168 ->
            match uu___4_6168 with
            | FStar_Syntax_Syntax.SOMETRIVIAL -> true
            | FStar_Syntax_Syntax.TRIVIAL_POSTCONDITION -> true
            | uu____6172 -> false) lc.FStar_TypeChecker_Common.cflags)
let (maybe_add_with_type :
  FStar_TypeChecker_Env.env ->
    FStar_Syntax_Syntax.universe FStar_Pervasives_Native.option ->
      FStar_TypeChecker_Common.lcomp ->
        FStar_Syntax_Syntax.term ->
          FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax)
  =
  fun env ->
    fun uopt ->
      fun lc ->
        fun e ->
          let uu____6201 =
            (FStar_TypeChecker_Common.is_lcomp_partial_return lc) ||
              env.FStar_TypeChecker_Env.lax in
          if uu____6201
          then e
          else
            (let uu____6208 =
               (lcomp_has_trivial_postcondition lc) &&
                 (let uu____6211 =
                    FStar_TypeChecker_Env.try_lookup_lid env
                      FStar_Parser_Const.with_type_lid in
                  FStar_Option.isSome uu____6211) in
             if uu____6208
             then
               let u =
                 match uopt with
                 | FStar_Pervasives_Native.Some u -> u
                 | FStar_Pervasives_Native.None ->
                     env.FStar_TypeChecker_Env.universe_of env
                       lc.FStar_TypeChecker_Common.res_typ in
               FStar_Syntax_Util.mk_with_type u
                 lc.FStar_TypeChecker_Common.res_typ e
             else e)
let (maybe_capture_unit_refinement :
  FStar_TypeChecker_Env.env ->
    FStar_Syntax_Syntax.term ->
      FStar_Syntax_Syntax.bv ->
        FStar_Syntax_Syntax.comp ->
          (FStar_Syntax_Syntax.comp * FStar_TypeChecker_Common.guard_t))
  =
  fun env ->
    fun t ->
      fun x ->
        fun c ->
          let t1 =
            FStar_TypeChecker_Normalize.normalize_refinement
              FStar_TypeChecker_Normalize.whnf_steps env t in
          match t1.FStar_Syntax_Syntax.n with
          | FStar_Syntax_Syntax.Tm_refine (b, phi) ->
              let is_unit =
                match (b.FStar_Syntax_Syntax.sort).FStar_Syntax_Syntax.n with
                | FStar_Syntax_Syntax.Tm_fvar fv ->
                    FStar_Syntax_Syntax.fv_eq_lid fv
                      FStar_Parser_Const.unit_lid
                | uu____6281 -> false in
              if is_unit
              then
                let uu____6288 =
                  let uu____6290 =
                    let uu____6291 =
                      FStar_All.pipe_right c
                        FStar_Syntax_Util.comp_effect_name in
                    FStar_All.pipe_right uu____6291
                      (FStar_TypeChecker_Env.norm_eff_name env) in
                  FStar_All.pipe_right uu____6290
                    (FStar_TypeChecker_Env.is_layered_effect env) in
                (if uu____6288
                 then
                   let uu____6300 = FStar_Syntax_Subst.open_term_bv b phi in
                   match uu____6300 with
                   | (b1, phi1) ->
                       let phi2 =
                         FStar_Syntax_Subst.subst
                           [FStar_Syntax_Syntax.NT
                              (b1, FStar_Syntax_Syntax.unit_const)] phi1 in
                       weaken_comp env c phi2
                 else
                   (let uu____6316 = close_wp_comp env [x] c in
                    (uu____6316, FStar_TypeChecker_Env.trivial_guard)))
              else (c, FStar_TypeChecker_Env.trivial_guard)
          | uu____6319 -> (c, FStar_TypeChecker_Env.trivial_guard)
let (bind :
  FStar_Range.range ->
    FStar_TypeChecker_Env.env ->
      FStar_Syntax_Syntax.term FStar_Pervasives_Native.option ->
        FStar_TypeChecker_Common.lcomp ->
          lcomp_with_binder -> FStar_TypeChecker_Common.lcomp)
  =
  fun r1 ->
    fun env ->
      fun e1opt ->
        fun lc1 ->
          fun uu____6347 ->
            match uu____6347 with
            | (b, lc2) ->
                let debug f =
                  let uu____6367 =
                    (FStar_TypeChecker_Env.debug env FStar_Options.Extreme)
                      ||
                      (FStar_All.pipe_left (FStar_TypeChecker_Env.debug env)
                         (FStar_Options.Other "bind")) in
                  if uu____6367 then f () else () in
                let lc11 =
                  FStar_TypeChecker_Normalize.ghost_to_pure_lcomp env lc1 in
                let lc21 =
                  FStar_TypeChecker_Normalize.ghost_to_pure_lcomp env lc2 in
                let joined_eff = join_lcomp env lc11 lc21 in
                let bind_flags =
                  let uu____6380 =
                    (should_not_inline_lc lc11) ||
                      (should_not_inline_lc lc21) in
                  if uu____6380
                  then [FStar_Syntax_Syntax.SHOULD_NOT_INLINE]
                  else
                    (let flags =
                       let uu____6390 =
                         FStar_TypeChecker_Common.is_total_lcomp lc11 in
                       if uu____6390
                       then
                         let uu____6395 =
                           FStar_TypeChecker_Common.is_total_lcomp lc21 in
                         (if uu____6395
                          then [FStar_Syntax_Syntax.TOTAL]
                          else
                            (let uu____6402 =
                               FStar_TypeChecker_Common.is_tot_or_gtot_lcomp
                                 lc21 in
                             if uu____6402
                             then [FStar_Syntax_Syntax.SOMETRIVIAL]
                             else []))
                       else
                         (let uu____6411 =
                            (FStar_TypeChecker_Common.is_tot_or_gtot_lcomp
                               lc11)
                              &&
                              (FStar_TypeChecker_Common.is_tot_or_gtot_lcomp
                                 lc21) in
                          if uu____6411
                          then [FStar_Syntax_Syntax.SOMETRIVIAL]
                          else []) in
                     let uu____6418 = lcomp_has_trivial_postcondition lc21 in
                     if uu____6418
                     then FStar_Syntax_Syntax.TRIVIAL_POSTCONDITION :: flags
                     else flags) in
                let bind_it uu____6434 =
                  let uu____6435 =
                    env.FStar_TypeChecker_Env.lax &&
                      (FStar_Options.ml_ish ()) in
                  if uu____6435
                  then
                    let u_t =
                      env.FStar_TypeChecker_Env.universe_of env
                        lc21.FStar_TypeChecker_Common.res_typ in
                    let uu____6443 =
                      lax_mk_tot_or_comp_l joined_eff u_t
                        lc21.FStar_TypeChecker_Common.res_typ [] in
                    (uu____6443, FStar_TypeChecker_Env.trivial_guard)
                  else
                    (let uu____6446 =
                       FStar_TypeChecker_Common.lcomp_comp lc11 in
                     match uu____6446 with
                     | (c1, g_c1) ->
                         let uu____6457 =
                           FStar_TypeChecker_Common.lcomp_comp lc21 in
                         (match uu____6457 with
                          | (c2, g_c2) ->
                              let trivial_guard =
                                let uu____6469 =
                                  match b with
                                  | FStar_Pervasives_Native.Some x ->
                                      let b1 =
                                        FStar_Syntax_Syntax.mk_binder x in
                                      let uu____6472 =
                                        FStar_Syntax_Syntax.is_null_binder b1 in
                                      if uu____6472
                                      then g_c2
                                      else
                                        FStar_TypeChecker_Env.close_guard env
                                          [b1] g_c2
                                  | FStar_Pervasives_Native.None -> g_c2 in
                                FStar_TypeChecker_Env.conj_guard g_c1
                                  uu____6469 in
                              (debug
                                 (fun uu____6498 ->
                                    let uu____6499 =
                                      FStar_Syntax_Print.comp_to_string c1 in
                                    let uu____6501 =
                                      match b with
                                      | FStar_Pervasives_Native.None ->
                                          "none"
                                      | FStar_Pervasives_Native.Some x ->
                                          FStar_Syntax_Print.bv_to_string x in
                                    let uu____6506 =
                                      FStar_Syntax_Print.comp_to_string c2 in
                                    FStar_Util.print3
                                      "(1) bind: \n\tc1=%s\n\tx=%s\n\tc2=%s\n(1. end bind)\n"
                                      uu____6499 uu____6501 uu____6506);
                               (let aux uu____6524 =
                                  let uu____6525 =
                                    FStar_Syntax_Util.is_trivial_wp c1 in
                                  if uu____6525
                                  then
                                    match b with
                                    | FStar_Pervasives_Native.None ->
                                        FStar_Util.Inl
                                          (c2, "trivial no binder")
                                    | FStar_Pervasives_Native.Some uu____6556
                                        ->
                                        let uu____6557 =
                                          FStar_Syntax_Util.is_ml_comp c2 in
                                        (if uu____6557
                                         then
                                           FStar_Util.Inl (c2, "trivial ml")
                                         else
                                           FStar_Util.Inr
                                             "c1 trivial; but c2 is not ML")
                                  else
                                    (let uu____6589 =
                                       (FStar_Syntax_Util.is_ml_comp c1) &&
                                         (FStar_Syntax_Util.is_ml_comp c2) in
                                     if uu____6589
                                     then FStar_Util.Inl (c2, "both ml")
                                     else
                                       FStar_Util.Inr
                                         "c1 not trivial, and both are not ML") in
                                let try_simplify uu____6636 =
                                  let aux_with_trivial_guard uu____6666 =
                                    let uu____6667 = aux () in
                                    match uu____6667 with
                                    | FStar_Util.Inl (c, reason) ->
                                        FStar_Util.Inl
                                          (c, trivial_guard, reason)
                                    | FStar_Util.Inr reason ->
                                        FStar_Util.Inr reason in
                                  let uu____6725 =
                                    let uu____6727 =
                                      FStar_TypeChecker_Env.try_lookup_effect_lid
                                        env
                                        FStar_Parser_Const.effect_GTot_lid in
                                    FStar_Option.isNone uu____6727 in
                                  if uu____6725
                                  then
                                    let uu____6743 =
                                      (FStar_Syntax_Util.is_tot_or_gtot_comp
                                         c1)
                                        &&
                                        (FStar_Syntax_Util.is_tot_or_gtot_comp
                                           c2) in
                                    (if uu____6743
                                     then
                                       FStar_Util.Inl
                                         (c2, trivial_guard,
                                           "Early in prims; we don't have bind yet")
                                     else
                                       (let uu____6770 =
                                          FStar_TypeChecker_Env.get_range env in
                                        FStar_Errors.raise_error
                                          (FStar_Errors.Fatal_NonTrivialPreConditionInPrims,
                                            "Non-trivial pre-conditions very early in prims, even before we have defined the PURE monad")
                                          uu____6770))
                                  else
                                    (let uu____6787 =
                                       FStar_Syntax_Util.is_total_comp c1 in
                                     if uu____6787
                                     then
                                       let close_with_type_of_x x c =
                                         let x1 =
                                           let uu___831_6818 = x in
                                           {
                                             FStar_Syntax_Syntax.ppname =
                                               (uu___831_6818.FStar_Syntax_Syntax.ppname);
                                             FStar_Syntax_Syntax.index =
                                               (uu___831_6818.FStar_Syntax_Syntax.index);
                                             FStar_Syntax_Syntax.sort =
                                               (FStar_Syntax_Util.comp_result
                                                  c1)
                                           } in
                                         maybe_capture_unit_refinement env
                                           x1.FStar_Syntax_Syntax.sort x1 c in
                                       match (e1opt, b) with
                                       | (FStar_Pervasives_Native.Some e,
                                          FStar_Pervasives_Native.Some x) ->
                                           let uu____6849 =
                                             let uu____6854 =
                                               FStar_All.pipe_right c2
                                                 (FStar_Syntax_Subst.subst_comp
                                                    [FStar_Syntax_Syntax.NT
                                                       (x, e)]) in
                                             FStar_All.pipe_right uu____6854
                                               (close_with_type_of_x x) in
                                           (match uu____6849 with
                                            | (c21, g_close) ->
                                                let uu____6875 =
                                                  let uu____6883 =
                                                    let uu____6884 =
                                                      let uu____6887 =
                                                        let uu____6890 =
                                                          FStar_TypeChecker_Env.map_guard
                                                            g_c2
                                                            (FStar_Syntax_Subst.subst
                                                               [FStar_Syntax_Syntax.NT
                                                                  (x, e)]) in
                                                        [uu____6890; g_close] in
                                                      g_c1 :: uu____6887 in
                                                    FStar_TypeChecker_Env.conj_guards
                                                      uu____6884 in
                                                  (c21, uu____6883, "c1 Tot") in
                                                FStar_Util.Inl uu____6875)
                                       | (uu____6903,
                                          FStar_Pervasives_Native.Some x) ->
                                           let uu____6915 =
                                             FStar_All.pipe_right c2
                                               (close_with_type_of_x x) in
                                           (match uu____6915 with
                                            | (c21, g_close) ->
                                                let uu____6938 =
                                                  let uu____6946 =
                                                    let uu____6947 =
                                                      let uu____6950 =
                                                        let uu____6953 =
                                                          let uu____6954 =
                                                            let uu____6955 =
                                                              FStar_Syntax_Syntax.mk_binder
                                                                x in
                                                            [uu____6955] in
                                                          FStar_TypeChecker_Env.close_guard
                                                            env uu____6954
                                                            g_c2 in
                                                        [uu____6953; g_close] in
                                                      g_c1 :: uu____6950 in
                                                    FStar_TypeChecker_Env.conj_guards
                                                      uu____6947 in
                                                  (c21, uu____6946,
                                                    "c1 Tot only close") in
                                                FStar_Util.Inl uu____6938)
                                       | (uu____6984, uu____6985) ->
                                           aux_with_trivial_guard ()
                                     else
                                       (let uu____7000 =
                                          (FStar_Syntax_Util.is_tot_or_gtot_comp
                                             c1)
                                            &&
                                            (FStar_Syntax_Util.is_tot_or_gtot_comp
                                               c2) in
                                        if uu____7000
                                        then
                                          let uu____7015 =
                                            let uu____7023 =
                                              FStar_Syntax_Syntax.mk_GTotal
                                                (FStar_Syntax_Util.comp_result
                                                   c2) in
                                            (uu____7023, trivial_guard,
                                              "both GTot") in
                                          FStar_Util.Inl uu____7015
                                        else aux_with_trivial_guard ())) in
                                let uu____7036 = try_simplify () in
                                match uu____7036 with
                                | FStar_Util.Inl (c, g, reason) ->
                                    (debug
                                       (fun uu____7071 ->
                                          let uu____7072 =
                                            FStar_Syntax_Print.comp_to_string
                                              c in
                                          FStar_Util.print2
                                            "(2) bind: Simplified (because %s) to\n\t%s\n"
                                            reason uu____7072);
                                     (c, g))
                                | FStar_Util.Inr reason ->
                                    (debug
                                       (fun uu____7088 ->
                                          FStar_Util.print1
                                            "(2) bind: Not simplified because %s\n"
                                            reason);
                                     (let mk_bind1 c11 b1 c21 g =
                                        let uu____7119 =
                                          mk_bind env c11 b1 c21 bind_flags
                                            r1 in
                                        match uu____7119 with
                                        | (c, g_bind) ->
                                            let uu____7130 =
                                              FStar_TypeChecker_Env.conj_guard
                                                g g_bind in
                                            (c, uu____7130) in
                                      let mk_seq c11 b1 c21 =
                                        let c12 =
                                          FStar_TypeChecker_Env.unfold_effect_abbrev
                                            env c11 in
                                        let c22 =
                                          FStar_TypeChecker_Env.unfold_effect_abbrev
                                            env c21 in
                                        let uu____7157 =
                                          FStar_TypeChecker_Env.join env
                                            c12.FStar_Syntax_Syntax.effect_name
                                            c22.FStar_Syntax_Syntax.effect_name in
                                        match uu____7157 with
                                        | (m, uu____7169, lift2) ->
                                            let uu____7171 =
                                              lift_comp env c22 lift2 in
                                            (match uu____7171 with
                                             | (c23, g2) ->
                                                 let uu____7182 =
                                                   destruct_wp_comp c12 in
                                                 (match uu____7182 with
                                                  | (u1, t1, wp1) ->
                                                      let md_pure_or_ghost =
                                                        FStar_TypeChecker_Env.get_effect_decl
                                                          env
                                                          c12.FStar_Syntax_Syntax.effect_name in
                                                      let trivial =
                                                        let uu____7198 =
                                                          FStar_All.pipe_right
                                                            md_pure_or_ghost
                                                            FStar_Syntax_Util.get_wp_trivial_combinator in
                                                        FStar_All.pipe_right
                                                          uu____7198
                                                          FStar_Util.must in
                                                      let vc1 =
                                                        let uu____7206 =
                                                          FStar_TypeChecker_Env.inst_effect_fun_with
                                                            [u1] env
                                                            md_pure_or_ghost
                                                            trivial in
                                                        let uu____7207 =
                                                          let uu____7208 =
                                                            FStar_Syntax_Syntax.as_arg
                                                              t1 in
                                                          let uu____7217 =
                                                            let uu____7228 =
                                                              FStar_Syntax_Syntax.as_arg
                                                                wp1 in
                                                            [uu____7228] in
                                                          uu____7208 ::
                                                            uu____7217 in
                                                        FStar_Syntax_Syntax.mk_Tm_app
                                                          uu____7206
                                                          uu____7207 r1 in
                                                      let uu____7261 =
                                                        strengthen_comp env
                                                          FStar_Pervasives_Native.None
                                                          c23 vc1 bind_flags in
                                                      (match uu____7261 with
                                                       | (c, g_s) ->
                                                           let uu____7276 =
                                                             FStar_TypeChecker_Env.conj_guards
                                                               [g_c1;
                                                               g_c2;
                                                               g2;
                                                               g_s] in
                                                           (c, uu____7276)))) in
                                      let uu____7277 =
                                        let t =
                                          FStar_Syntax_Util.comp_result c1 in
                                        match comp_univ_opt c1 with
                                        | FStar_Pervasives_Native.None ->
                                            let uu____7293 =
                                              env.FStar_TypeChecker_Env.universe_of
                                                env t in
                                            (uu____7293, t)
                                        | FStar_Pervasives_Native.Some u ->
                                            (u, t) in
                                      match uu____7277 with
                                      | (u_res_t1, res_t1) ->
                                          let uu____7309 =
                                            (FStar_Option.isSome b) &&
                                              (should_return env e1opt lc11) in
                                          if uu____7309
                                          then
                                            let e1 = FStar_Option.get e1opt in
                                            let x = FStar_Option.get b in
                                            let uu____7318 =
                                              FStar_Syntax_Util.is_partial_return
                                                c1 in
                                            (if uu____7318
                                             then
                                               (debug
                                                  (fun uu____7332 ->
                                                     let uu____7333 =
                                                       FStar_TypeChecker_Normalize.term_to_string
                                                         env e1 in
                                                     let uu____7335 =
                                                       FStar_Syntax_Print.bv_to_string
                                                         x in
                                                     FStar_Util.print2
                                                       "(3) bind (case a): Substituting %s for %s"
                                                       uu____7333 uu____7335);
                                                (let c21 =
                                                   FStar_Syntax_Subst.subst_comp
                                                     [FStar_Syntax_Syntax.NT
                                                        (x, e1)] c2 in
                                                 let g =
                                                   let uu____7342 =
                                                     FStar_TypeChecker_Env.map_guard
                                                       g_c2
                                                       (FStar_Syntax_Subst.subst
                                                          [FStar_Syntax_Syntax.NT
                                                             (x, e1)]) in
                                                   FStar_TypeChecker_Env.conj_guard
                                                     g_c1 uu____7342 in
                                                 mk_bind1 c1 b c21 g))
                                             else
                                               (let uu____7347 =
                                                  ((FStar_Options.vcgen_optimize_bind_as_seq
                                                      ())
                                                     &&
                                                     (lcomp_has_trivial_postcondition
                                                        lc11))
                                                    &&
                                                    (let uu____7350 =
                                                       FStar_TypeChecker_Env.try_lookup_lid
                                                         env
                                                         FStar_Parser_Const.with_type_lid in
                                                     FStar_Option.isSome
                                                       uu____7350) in
                                                if uu____7347
                                                then
                                                  let e1' =
                                                    let uu____7375 =
                                                      FStar_Options.vcgen_decorate_with_type
                                                        () in
                                                    if uu____7375
                                                    then
                                                      FStar_Syntax_Util.mk_with_type
                                                        u_res_t1 res_t1 e1
                                                    else e1 in
                                                  (debug
                                                     (fun uu____7387 ->
                                                        let uu____7388 =
                                                          FStar_TypeChecker_Normalize.term_to_string
                                                            env e1' in
                                                        let uu____7390 =
                                                          FStar_Syntax_Print.bv_to_string
                                                            x in
                                                        FStar_Util.print2
                                                          "(3) bind (case b): Substituting %s for %s"
                                                          uu____7388
                                                          uu____7390);
                                                   (let c21 =
                                                      FStar_Syntax_Subst.subst_comp
                                                        [FStar_Syntax_Syntax.NT
                                                           (x, e1')] c2 in
                                                    mk_seq c1 b c21))
                                                else
                                                  (debug
                                                     (fun uu____7405 ->
                                                        let uu____7406 =
                                                          FStar_TypeChecker_Normalize.term_to_string
                                                            env e1 in
                                                        let uu____7408 =
                                                          FStar_Syntax_Print.bv_to_string
                                                            x in
                                                        FStar_Util.print2
                                                          "(3) bind (case c): Adding equality %s = %s"
                                                          uu____7406
                                                          uu____7408);
                                                   (let c21 =
                                                      FStar_Syntax_Subst.subst_comp
                                                        [FStar_Syntax_Syntax.NT
                                                           (x, e1)] c2 in
                                                    let x_eq_e =
                                                      let uu____7415 =
                                                        FStar_Syntax_Syntax.bv_to_name
                                                          x in
                                                      FStar_Syntax_Util.mk_eq2
                                                        u_res_t1 res_t1 e1
                                                        uu____7415 in
                                                    let uu____7416 =
                                                      let uu____7421 =
                                                        let uu____7422 =
                                                          let uu____7423 =
                                                            FStar_Syntax_Syntax.mk_binder
                                                              x in
                                                          [uu____7423] in
                                                        FStar_TypeChecker_Env.push_binders
                                                          env uu____7422 in
                                                      weaken_comp uu____7421
                                                        c21 x_eq_e in
                                                    match uu____7416 with
                                                    | (c22, g_w) ->
                                                        let g =
                                                          let uu____7449 =
                                                            let uu____7450 =
                                                              let uu____7451
                                                                =
                                                                FStar_Syntax_Syntax.mk_binder
                                                                  x in
                                                              [uu____7451] in
                                                            let uu____7470 =
                                                              FStar_TypeChecker_Common.weaken_guard_formula
                                                                g_c2 x_eq_e in
                                                            FStar_TypeChecker_Env.close_guard
                                                              env uu____7450
                                                              uu____7470 in
                                                          FStar_TypeChecker_Env.conj_guard
                                                            g_c1 uu____7449 in
                                                        let uu____7471 =
                                                          mk_bind1 c1 b c22 g in
                                                        (match uu____7471
                                                         with
                                                         | (c, g_bind) ->
                                                             let uu____7482 =
                                                               FStar_TypeChecker_Env.conj_guard
                                                                 g_w g_bind in
                                                             (c, uu____7482))))))
                                          else mk_bind1 c1 b c2 trivial_guard)))))) in
                FStar_TypeChecker_Common.mk_lcomp joined_eff
                  lc21.FStar_TypeChecker_Common.res_typ bind_flags bind_it
let (weaken_guard :
  FStar_TypeChecker_Common.guard_formula ->
    FStar_TypeChecker_Common.guard_formula ->
      FStar_TypeChecker_Common.guard_formula)
  =
  fun g1 ->
    fun g2 ->
      match (g1, g2) with
      | (FStar_TypeChecker_Common.NonTrivial f1,
         FStar_TypeChecker_Common.NonTrivial f2) ->
          let g = FStar_Syntax_Util.mk_imp f1 f2 in
          FStar_TypeChecker_Common.NonTrivial g
      | uu____7499 -> g2
let (maybe_assume_result_eq_pure_term_in_m :
  FStar_TypeChecker_Env.env ->
    FStar_Ident.lident FStar_Pervasives_Native.option ->
      FStar_Syntax_Syntax.term ->
        FStar_TypeChecker_Common.lcomp -> FStar_TypeChecker_Common.lcomp)
  =
  fun env ->
    fun m_opt ->
      fun e ->
        fun lc ->
          let should_return1 =
            (((Prims.op_Negation env.FStar_TypeChecker_Env.lax) &&
                (FStar_TypeChecker_Env.lid_exists env
                   FStar_Parser_Const.effect_GTot_lid))
               && (should_return env (FStar_Pervasives_Native.Some e) lc))
              &&
              (let uu____7532 =
                 FStar_TypeChecker_Common.is_lcomp_partial_return lc in
               Prims.op_Negation uu____7532) in
          let m =
            let uu____7535 =
              ((FStar_All.pipe_right m_opt FStar_Util.is_none) ||
                 (FStar_Options.ml_ish ()))
                || (is_ghost_effect env lc.FStar_TypeChecker_Common.eff_name) in
            if uu____7535
            then FStar_Parser_Const.effect_PURE_lid
            else FStar_All.pipe_right m_opt FStar_Util.must in
          let flags =
            if should_return1
            then
              let uu____7551 = FStar_TypeChecker_Common.is_total_lcomp lc in
              (if uu____7551
               then FStar_Syntax_Syntax.RETURN ::
                 (lc.FStar_TypeChecker_Common.cflags)
               else FStar_Syntax_Syntax.PARTIAL_RETURN ::
                 (lc.FStar_TypeChecker_Common.cflags))
            else lc.FStar_TypeChecker_Common.cflags in
          let refine uu____7569 =
            let uu____7574 = FStar_TypeChecker_Common.lcomp_comp lc in
            match uu____7574 with
            | (c, g_c) ->
                let u_t =
                  match comp_univ_opt c with
                  | FStar_Pervasives_Native.Some u_t -> u_t
                  | FStar_Pervasives_Native.None ->
                      env.FStar_TypeChecker_Env.universe_of env
                        (FStar_Syntax_Util.comp_result c) in
                let uu____7587 = FStar_Syntax_Util.is_tot_or_gtot_comp c in
                if uu____7587
                then
                  let uu____7594 =
                    return_value env m (FStar_Pervasives_Native.Some u_t)
                      (FStar_Syntax_Util.comp_result c) e in
                  (match uu____7594 with
                   | (retc, g_retc) ->
                       let g_c1 = FStar_TypeChecker_Env.conj_guard g_c g_retc in
                       let uu____7606 =
                         let uu____7608 = FStar_Syntax_Util.is_pure_comp c in
                         Prims.op_Negation uu____7608 in
                       if uu____7606
                       then
                         let retc1 = FStar_Syntax_Util.comp_to_comp_typ retc in
                         let retc2 =
                           let uu___962_7617 = retc1 in
                           {
                             FStar_Syntax_Syntax.comp_univs =
                               (uu___962_7617.FStar_Syntax_Syntax.comp_univs);
                             FStar_Syntax_Syntax.effect_name =
                               FStar_Parser_Const.effect_GHOST_lid;
                             FStar_Syntax_Syntax.result_typ =
                               (uu___962_7617.FStar_Syntax_Syntax.result_typ);
                             FStar_Syntax_Syntax.effect_args =
                               (uu___962_7617.FStar_Syntax_Syntax.effect_args);
                             FStar_Syntax_Syntax.flags = flags
                           } in
                         let uu____7618 = FStar_Syntax_Syntax.mk_Comp retc2 in
                         (uu____7618, g_c1)
                       else
                         (let uu____7621 =
                            FStar_Syntax_Util.comp_set_flags retc flags in
                          (uu____7621, g_c1)))
                else
                  (let c1 = FStar_TypeChecker_Env.unfold_effect_abbrev env c in
                   let t = c1.FStar_Syntax_Syntax.result_typ in
                   let c2 = FStar_Syntax_Syntax.mk_Comp c1 in
                   let x =
                     FStar_Syntax_Syntax.new_bv
                       (FStar_Pervasives_Native.Some
                          (t.FStar_Syntax_Syntax.pos)) t in
                   let xexp = FStar_Syntax_Syntax.bv_to_name x in
                   let env_x = FStar_TypeChecker_Env.push_bv env x in
                   let uu____7632 =
                     return_value env_x m (FStar_Pervasives_Native.Some u_t)
                       t xexp in
                   match uu____7632 with
                   | (ret, g_ret) ->
                       let ret1 =
                         let uu____7644 =
                           FStar_Syntax_Util.comp_set_flags ret
                             [FStar_Syntax_Syntax.PARTIAL_RETURN] in
                         FStar_All.pipe_left
                           FStar_TypeChecker_Common.lcomp_of_comp uu____7644 in
                       let eq = FStar_Syntax_Util.mk_eq2 u_t t xexp e in
                       let eq_ret =
                         weaken_precondition env_x ret1
                           (FStar_TypeChecker_Common.NonTrivial eq) in
                       let uu____7647 =
                         let uu____7652 =
                           let uu____7653 =
                             FStar_TypeChecker_Common.lcomp_of_comp c2 in
                           bind e.FStar_Syntax_Syntax.pos env
                             FStar_Pervasives_Native.None uu____7653
                             ((FStar_Pervasives_Native.Some x), eq_ret) in
                         FStar_TypeChecker_Common.lcomp_comp uu____7652 in
                       (match uu____7647 with
                        | (bind_c, g_bind) ->
                            let uu____7662 =
                              FStar_Syntax_Util.comp_set_flags bind_c flags in
                            let uu____7663 =
                              FStar_TypeChecker_Env.conj_guards
                                [g_c; g_ret; g_bind] in
                            (uu____7662, uu____7663))) in
          if Prims.op_Negation should_return1
          then lc
          else
            (let uu____7667 = refine () in
             match uu____7667 with
             | (c, g) -> FStar_TypeChecker_Common.lcomp_of_comp_guard c g)
let (maybe_assume_result_eq_pure_term :
  FStar_TypeChecker_Env.env ->
    FStar_Syntax_Syntax.term ->
      FStar_TypeChecker_Common.lcomp -> FStar_TypeChecker_Common.lcomp)
  =
  fun env ->
    fun e ->
      fun lc ->
        maybe_assume_result_eq_pure_term_in_m env
          FStar_Pervasives_Native.None e lc
let (maybe_return_e2_and_bind :
  FStar_Range.range ->
    FStar_TypeChecker_Env.env ->
      FStar_Syntax_Syntax.term FStar_Pervasives_Native.option ->
        FStar_TypeChecker_Common.lcomp ->
          FStar_Syntax_Syntax.term ->
            lcomp_with_binder -> FStar_TypeChecker_Common.lcomp)
  =
  fun r ->
    fun env ->
      fun e1opt ->
        fun lc1 ->
          fun e2 ->
            fun uu____7722 ->
              match uu____7722 with
              | (x, lc2) ->
                  let lc21 =
                    let eff1 =
                      FStar_TypeChecker_Env.norm_eff_name env
                        lc1.FStar_TypeChecker_Common.eff_name in
                    let eff2 =
                      FStar_TypeChecker_Env.norm_eff_name env
                        lc2.FStar_TypeChecker_Common.eff_name in
                    let uu____7734 =
                      ((let uu____7738 = is_pure_or_ghost_effect env eff1 in
                        Prims.op_Negation uu____7738) ||
                         (should_not_inline_lc lc1))
                        && (is_pure_or_ghost_effect env eff2) in
                    if uu____7734
                    then
                      let env_x =
                        match x with
                        | FStar_Pervasives_Native.None -> env
                        | FStar_Pervasives_Native.Some x1 ->
                            FStar_TypeChecker_Env.push_bv env x1 in
                      let uu____7743 =
                        FStar_All.pipe_right eff1
                          (fun uu____7748 ->
                             FStar_Pervasives_Native.Some uu____7748) in
                      maybe_assume_result_eq_pure_term_in_m env_x uu____7743
                        e2 lc2
                    else lc2 in
                  bind r env e1opt lc1 (x, lc21)
let (fvar_const :
  FStar_TypeChecker_Env.env -> FStar_Ident.lident -> FStar_Syntax_Syntax.term)
  =
  fun env ->
    fun lid ->
      let uu____7764 =
        let uu____7765 = FStar_TypeChecker_Env.get_range env in
        FStar_Ident.set_lid_range lid uu____7765 in
      FStar_Syntax_Syntax.fvar uu____7764 FStar_Syntax_Syntax.delta_constant
        FStar_Pervasives_Native.None
let (mk_layered_conjunction :
  FStar_TypeChecker_Env.env ->
    FStar_Syntax_Syntax.eff_decl ->
      FStar_Syntax_Syntax.universe ->
        FStar_Syntax_Syntax.term ->
          FStar_Syntax_Syntax.typ ->
            FStar_Syntax_Syntax.comp_typ ->
              FStar_Syntax_Syntax.comp_typ ->
                FStar_Range.range ->
                  (FStar_Syntax_Syntax.comp *
                    FStar_TypeChecker_Common.guard_t))
  =
  fun env ->
    fun ed ->
      fun u_a ->
        fun a ->
          fun p ->
            fun ct1 ->
              fun ct2 ->
                fun r ->
                  let uu____7815 =
                    let uu____7820 =
                      let uu____7821 =
                        FStar_All.pipe_right ed
                          FStar_Syntax_Util.get_layered_if_then_else_combinator in
                      FStar_All.pipe_right uu____7821 FStar_Util.must in
                    FStar_TypeChecker_Env.inst_tscheme_with uu____7820 [u_a] in
                  match uu____7815 with
                  | (uu____7832, conjunction) ->
                      let uu____7834 =
                        let uu____7843 =
                          FStar_List.map FStar_Pervasives_Native.fst
                            ct1.FStar_Syntax_Syntax.effect_args in
                        let uu____7858 =
                          FStar_List.map FStar_Pervasives_Native.fst
                            ct2.FStar_Syntax_Syntax.effect_args in
                        (uu____7843, uu____7858) in
                      (match uu____7834 with
                       | (is1, is2) ->
                           let conjunction_t_error s =
                             let uu____7904 =
                               let uu____7906 =
                                 FStar_Syntax_Print.term_to_string
                                   conjunction in
                               FStar_Util.format2
                                 "conjunction %s does not have proper shape (reason:%s)"
                                 uu____7906 s in
                             (FStar_Errors.Fatal_UnexpectedEffect,
                               uu____7904) in
                           let uu____7910 =
                             let uu____7955 =
                               let uu____7956 =
                                 FStar_Syntax_Subst.compress conjunction in
                               uu____7956.FStar_Syntax_Syntax.n in
                             match uu____7955 with
                             | FStar_Syntax_Syntax.Tm_abs
                                 (bs, body, uu____8005) when
                                 (FStar_List.length bs) >= (Prims.of_int (4))
                                 ->
                                 let uu____8037 =
                                   FStar_Syntax_Subst.open_term bs body in
                                 (match uu____8037 with
                                  | (a_b::bs1, body1) ->
                                      let uu____8109 =
                                        FStar_List.splitAt
                                          ((FStar_List.length bs1) -
                                             (Prims.of_int (3))) bs1 in
                                      (match uu____8109 with
                                       | (rest_bs, f_b::g_b::p_b::[]) ->
                                           let uu____8257 =
                                             FStar_All.pipe_right body1
                                               FStar_Syntax_Util.unascribe in
                                           (a_b, rest_bs, f_b, g_b, p_b,
                                             uu____8257)))
                             | uu____8290 ->
                                 let uu____8291 =
                                   conjunction_t_error
                                     "Either not an abstraction or not enough binders" in
                                 FStar_Errors.raise_error uu____8291 r in
                           (match uu____7910 with
                            | (a_b, rest_bs, f_b, g_b, p_b, body) ->
                                let uu____8416 =
                                  let uu____8423 =
                                    let uu____8424 =
                                      let uu____8425 =
                                        let uu____8432 =
                                          FStar_All.pipe_right a_b
                                            FStar_Pervasives_Native.fst in
                                        (uu____8432, a) in
                                      FStar_Syntax_Syntax.NT uu____8425 in
                                    [uu____8424] in
                                  FStar_TypeChecker_Env.uvars_for_binders env
                                    rest_bs uu____8423
                                    (fun b ->
                                       let uu____8448 =
                                         FStar_Syntax_Print.binder_to_string
                                           b in
                                       let uu____8450 =
                                         FStar_Ident.string_of_lid
                                           ed.FStar_Syntax_Syntax.mname in
                                       let uu____8452 =
                                         FStar_All.pipe_right r
                                           FStar_Range.string_of_range in
                                       FStar_Util.format3
                                         "implicit var for binder %s of %s:conjunction at %s"
                                         uu____8448 uu____8450 uu____8452) r in
                                (match uu____8416 with
                                 | (rest_bs_uvars, g_uvars) ->
                                     let substs =
                                       FStar_List.map2
                                         (fun b ->
                                            fun t ->
                                              let uu____8490 =
                                                let uu____8497 =
                                                  FStar_All.pipe_right b
                                                    FStar_Pervasives_Native.fst in
                                                (uu____8497, t) in
                                              FStar_Syntax_Syntax.NT
                                                uu____8490) (a_b ::
                                         (FStar_List.append rest_bs [p_b]))
                                         (a ::
                                         (FStar_List.append rest_bs_uvars [p])) in
                                     let f_guard =
                                       let f_sort_is =
                                         let uu____8536 =
                                           let uu____8537 =
                                             let uu____8540 =
                                               let uu____8541 =
                                                 FStar_All.pipe_right f_b
                                                   FStar_Pervasives_Native.fst in
                                               uu____8541.FStar_Syntax_Syntax.sort in
                                             FStar_Syntax_Subst.compress
                                               uu____8540 in
                                           uu____8537.FStar_Syntax_Syntax.n in
                                         match uu____8536 with
                                         | FStar_Syntax_Syntax.Tm_app
                                             (uu____8552, uu____8553::is) ->
                                             let uu____8595 =
                                               FStar_All.pipe_right is
                                                 (FStar_List.map
                                                    FStar_Pervasives_Native.fst) in
                                             FStar_All.pipe_right uu____8595
                                               (FStar_List.map
                                                  (FStar_Syntax_Subst.subst
                                                     substs))
                                         | uu____8628 ->
                                             let uu____8629 =
                                               conjunction_t_error
                                                 "f's type is not a repr type" in
                                             FStar_Errors.raise_error
                                               uu____8629 r in
                                       FStar_List.fold_left2
                                         (fun g ->
                                            fun i1 ->
                                              fun f_i ->
                                                let uu____8645 =
                                                  FStar_TypeChecker_Rel.teq
                                                    env i1 f_i in
                                                FStar_TypeChecker_Env.conj_guard
                                                  g uu____8645)
                                         FStar_TypeChecker_Env.trivial_guard
                                         is1 f_sort_is in
                                     let g_guard =
                                       let g_sort_is =
                                         let uu____8650 =
                                           let uu____8651 =
                                             let uu____8654 =
                                               let uu____8655 =
                                                 FStar_All.pipe_right g_b
                                                   FStar_Pervasives_Native.fst in
                                               uu____8655.FStar_Syntax_Syntax.sort in
                                             FStar_Syntax_Subst.compress
                                               uu____8654 in
                                           uu____8651.FStar_Syntax_Syntax.n in
                                         match uu____8650 with
                                         | FStar_Syntax_Syntax.Tm_app
                                             (uu____8666, uu____8667::is) ->
                                             let uu____8709 =
                                               FStar_All.pipe_right is
                                                 (FStar_List.map
                                                    FStar_Pervasives_Native.fst) in
                                             FStar_All.pipe_right uu____8709
                                               (FStar_List.map
                                                  (FStar_Syntax_Subst.subst
                                                     substs))
                                         | uu____8742 ->
                                             let uu____8743 =
                                               conjunction_t_error
                                                 "g's type is not a repr type" in
                                             FStar_Errors.raise_error
                                               uu____8743 r in
                                       FStar_List.fold_left2
                                         (fun g ->
                                            fun i2 ->
                                              fun g_i ->
                                                let uu____8759 =
                                                  FStar_TypeChecker_Rel.teq
                                                    env i2 g_i in
                                                FStar_TypeChecker_Env.conj_guard
                                                  g uu____8759)
                                         FStar_TypeChecker_Env.trivial_guard
                                         is2 g_sort_is in
                                     let body1 =
                                       FStar_Syntax_Subst.subst substs body in
                                     let is =
                                       let uu____8764 =
                                         let uu____8765 =
                                           FStar_Syntax_Subst.compress body1 in
                                         uu____8765.FStar_Syntax_Syntax.n in
                                       match uu____8764 with
                                       | FStar_Syntax_Syntax.Tm_app
                                           (uu____8770, a1::args) ->
                                           FStar_List.map
                                             FStar_Pervasives_Native.fst args
                                       | uu____8825 ->
                                           let uu____8826 =
                                             conjunction_t_error
                                               "body is not a repr type" in
                                           FStar_Errors.raise_error
                                             uu____8826 r in
                                     let uu____8835 =
                                       let uu____8836 =
                                         let uu____8837 =
                                           FStar_All.pipe_right is
                                             (FStar_List.map
                                                FStar_Syntax_Syntax.as_arg) in
                                         {
                                           FStar_Syntax_Syntax.comp_univs =
                                             [u_a];
                                           FStar_Syntax_Syntax.effect_name =
                                             (ed.FStar_Syntax_Syntax.mname);
                                           FStar_Syntax_Syntax.result_typ = a;
                                           FStar_Syntax_Syntax.effect_args =
                                             uu____8837;
                                           FStar_Syntax_Syntax.flags = []
                                         } in
                                       FStar_Syntax_Syntax.mk_Comp uu____8836 in
                                     let uu____8860 =
                                       let uu____8861 =
                                         FStar_TypeChecker_Env.conj_guard
                                           g_uvars f_guard in
                                       FStar_TypeChecker_Env.conj_guard
                                         uu____8861 g_guard in
                                     (uu____8835, uu____8860))))
let (mk_non_layered_conjunction :
  FStar_TypeChecker_Env.env ->
    FStar_Syntax_Syntax.eff_decl ->
      FStar_Syntax_Syntax.universe ->
        FStar_Syntax_Syntax.term ->
          FStar_Syntax_Syntax.typ ->
            FStar_Syntax_Syntax.comp_typ ->
              FStar_Syntax_Syntax.comp_typ ->
                FStar_Range.range ->
                  (FStar_Syntax_Syntax.comp *
                    FStar_TypeChecker_Common.guard_t))
  =
  fun env ->
    fun ed ->
      fun u_a ->
        fun a ->
          fun p ->
            fun ct1 ->
              fun ct2 ->
                fun uu____8906 ->
                  let if_then_else =
                    let uu____8912 =
                      FStar_All.pipe_right ed
                        FStar_Syntax_Util.get_wp_if_then_else_combinator in
                    FStar_All.pipe_right uu____8912 FStar_Util.must in
                  let uu____8919 = destruct_wp_comp ct1 in
                  match uu____8919 with
                  | (uu____8930, uu____8931, wp_t) ->
                      let uu____8933 = destruct_wp_comp ct2 in
                      (match uu____8933 with
                       | (uu____8944, uu____8945, wp_e) ->
                           let wp =
                             let uu____8948 =
                               FStar_TypeChecker_Env.inst_effect_fun_with
                                 [u_a] env ed if_then_else in
                             let uu____8949 =
                               let uu____8950 = FStar_Syntax_Syntax.as_arg a in
                               let uu____8959 =
                                 let uu____8970 =
                                   FStar_Syntax_Syntax.as_arg p in
                                 let uu____8979 =
                                   let uu____8990 =
                                     FStar_Syntax_Syntax.as_arg wp_t in
                                   let uu____8999 =
                                     let uu____9010 =
                                       FStar_Syntax_Syntax.as_arg wp_e in
                                     [uu____9010] in
                                   uu____8990 :: uu____8999 in
                                 uu____8970 :: uu____8979 in
                               uu____8950 :: uu____8959 in
                             let uu____9059 =
                               FStar_Range.union_ranges
                                 wp_t.FStar_Syntax_Syntax.pos
                                 wp_e.FStar_Syntax_Syntax.pos in
                             FStar_Syntax_Syntax.mk_Tm_app uu____8948
                               uu____8949 uu____9059 in
                           let uu____9060 = mk_comp ed u_a a wp [] in
                           (uu____9060, FStar_TypeChecker_Env.trivial_guard))
let (comp_pure_wp_false :
  FStar_TypeChecker_Env.env ->
    FStar_Syntax_Syntax.universe ->
      FStar_Syntax_Syntax.typ -> FStar_Syntax_Syntax.comp)
  =
  fun env ->
    fun u ->
      fun t ->
        let post_k =
          let uu____9080 =
            let uu____9089 = FStar_Syntax_Syntax.null_binder t in
            [uu____9089] in
          let uu____9108 =
            FStar_Syntax_Syntax.mk_Total FStar_Syntax_Util.ktype0 in
          FStar_Syntax_Util.arrow uu____9080 uu____9108 in
        let kwp =
          let uu____9114 =
            let uu____9123 = FStar_Syntax_Syntax.null_binder post_k in
            [uu____9123] in
          let uu____9142 =
            FStar_Syntax_Syntax.mk_Total FStar_Syntax_Util.ktype0 in
          FStar_Syntax_Util.arrow uu____9114 uu____9142 in
        let post =
          FStar_Syntax_Syntax.new_bv FStar_Pervasives_Native.None post_k in
        let wp =
          let uu____9149 =
            let uu____9150 = FStar_Syntax_Syntax.mk_binder post in
            [uu____9150] in
          let uu____9169 = fvar_const env FStar_Parser_Const.false_lid in
          FStar_Syntax_Util.abs uu____9149 uu____9169
            (FStar_Pervasives_Native.Some
               (FStar_Syntax_Util.mk_residual_comp
                  FStar_Parser_Const.effect_Tot_lid
                  FStar_Pervasives_Native.None [FStar_Syntax_Syntax.TOTAL])) in
        let md =
          FStar_TypeChecker_Env.get_effect_decl env
            FStar_Parser_Const.effect_PURE_lid in
        mk_comp md u t wp []
let (bind_cases :
  FStar_TypeChecker_Env.env ->
    FStar_Syntax_Syntax.typ ->
      (FStar_Syntax_Syntax.typ * FStar_Ident.lident *
        FStar_Syntax_Syntax.cflag Prims.list *
        (Prims.bool -> FStar_TypeChecker_Common.lcomp)) Prims.list ->
        FStar_Syntax_Syntax.bv -> FStar_TypeChecker_Common.lcomp)
  =
  fun env0 ->
    fun res_t ->
      fun lcases ->
        fun scrutinee ->
          let env =
            let uu____9228 =
              let uu____9229 =
                FStar_All.pipe_right scrutinee FStar_Syntax_Syntax.mk_binder in
              [uu____9229] in
            FStar_TypeChecker_Env.push_binders env0 uu____9228 in
          let eff =
            FStar_List.fold_left
              (fun eff ->
                 fun uu____9276 ->
                   match uu____9276 with
                   | (uu____9290, eff_label, uu____9292, uu____9293) ->
                       join_effects env eff eff_label)
              FStar_Parser_Const.effect_PURE_lid lcases in
          let uu____9306 =
            let uu____9314 =
              FStar_All.pipe_right lcases
                (FStar_Util.for_some
                   (fun uu____9352 ->
                      match uu____9352 with
                      | (uu____9367, uu____9368, flags, uu____9370) ->
                          FStar_All.pipe_right flags
                            (FStar_Util.for_some
                               (fun uu___5_9387 ->
                                  match uu___5_9387 with
                                  | FStar_Syntax_Syntax.SHOULD_NOT_INLINE ->
                                      true
                                  | uu____9390 -> false)))) in
            if uu____9314
            then (true, [FStar_Syntax_Syntax.SHOULD_NOT_INLINE])
            else (false, []) in
          match uu____9306 with
          | (should_not_inline_whole_match, bind_cases_flags) ->
              let bind_cases uu____9427 =
                let u_res_t = env.FStar_TypeChecker_Env.universe_of env res_t in
                let uu____9429 =
                  env.FStar_TypeChecker_Env.lax && (FStar_Options.ml_ish ()) in
                if uu____9429
                then
                  let uu____9436 = lax_mk_tot_or_comp_l eff u_res_t res_t [] in
                  (uu____9436, FStar_TypeChecker_Env.trivial_guard)
                else
                  (let maybe_return eff_label_then cthen =
                     let uu____9457 =
                       should_not_inline_whole_match ||
                         (let uu____9460 = is_pure_or_ghost_effect env eff in
                          Prims.op_Negation uu____9460) in
                     if uu____9457 then cthen true else cthen false in
                   let uu____9467 =
                     let uu____9478 =
                       let uu____9491 =
                         let uu____9496 =
                           let uu____9507 =
                             FStar_All.pipe_right lcases
                               (FStar_List.map
                                  (fun uu____9557 ->
                                     match uu____9557 with
                                     | (g, uu____9576, uu____9577,
                                        uu____9578) -> g)) in
                           FStar_All.pipe_right uu____9507
                             (FStar_List.fold_left
                                (fun uu____9626 ->
                                   fun g ->
                                     match uu____9626 with
                                     | (conds, acc) ->
                                         let cond =
                                           let uu____9667 =
                                             FStar_Syntax_Util.mk_neg g in
                                           FStar_Syntax_Util.mk_conj acc
                                             uu____9667 in
                                         ((FStar_List.append conds [cond]),
                                           cond))
                                ([FStar_Syntax_Util.t_true],
                                  FStar_Syntax_Util.t_true)) in
                         FStar_All.pipe_right uu____9496
                           FStar_Pervasives_Native.fst in
                       FStar_All.pipe_right uu____9491
                         (fun l ->
                            FStar_List.splitAt
                              ((FStar_List.length l) - Prims.int_one) l) in
                     FStar_All.pipe_right uu____9478
                       (fun uu____9765 ->
                          match uu____9765 with
                          | (l1, l2) ->
                              let uu____9806 = FStar_List.hd l2 in
                              (l1, uu____9806)) in
                   match uu____9467 with
                   | (neg_branch_conds, exhaustiveness_branch_cond) ->
                       let uu____9835 =
                         match lcases with
                         | [] ->
                             let uu____9866 =
                               comp_pure_wp_false env u_res_t res_t in
                             (FStar_Pervasives_Native.None, uu____9866,
                               FStar_TypeChecker_Env.trivial_guard)
                         | uu____9869 ->
                             let uu____9886 =
                               let uu____9919 =
                                 let uu____9930 =
                                   FStar_All.pipe_right neg_branch_conds
                                     (FStar_List.splitAt
                                        ((FStar_List.length lcases) -
                                           Prims.int_one)) in
                                 FStar_All.pipe_right uu____9930
                                   (fun uu____10002 ->
                                      match uu____10002 with
                                      | (l1, l2) ->
                                          let uu____10043 = FStar_List.hd l2 in
                                          (l1, uu____10043)) in
                               match uu____9919 with
                               | (neg_branch_conds1, neg_last) ->
                                   let uu____10100 =
                                     let uu____10139 =
                                       FStar_All.pipe_right lcases
                                         (FStar_List.splitAt
                                            ((FStar_List.length lcases) -
                                               Prims.int_one)) in
                                     FStar_All.pipe_right uu____10139
                                       (fun uu____10351 ->
                                          match uu____10351 with
                                          | (l1, l2) ->
                                              let uu____10502 =
                                                FStar_List.hd l2 in
                                              (l1, uu____10502)) in
                                   (match uu____10100 with
                                    | (lcases1,
                                       (g_last, eff_last, uu____10604,
                                        c_last)) ->
                                        let uu____10674 =
                                          let lc =
                                            maybe_return eff_last c_last in
                                          let uu____10680 =
                                            FStar_TypeChecker_Common.lcomp_comp
                                              lc in
                                          match uu____10680 with
                                          | (c, g) ->
                                              let uu____10691 =
                                                let uu____10692 =
                                                  FStar_Syntax_Util.mk_conj
                                                    g_last neg_last in
                                                FStar_TypeChecker_Common.weaken_guard_formula
                                                  g uu____10692 in
                                              (c, uu____10691) in
                                        (match uu____10674 with
                                         | (c, g) ->
                                             let uu____10727 =
                                               let uu____10728 =
                                                 FStar_All.pipe_right
                                                   eff_last
                                                   (FStar_TypeChecker_Env.norm_eff_name
                                                      env) in
                                               FStar_All.pipe_right
                                                 uu____10728
                                                 (FStar_TypeChecker_Env.get_effect_decl
                                                    env) in
                                             (lcases1, neg_branch_conds1,
                                               uu____10727, c, g))) in
                             (match uu____9886 with
                              | (lcases1, neg_branch_conds1, md, comp,
                                 g_comp) ->
                                  FStar_List.fold_right2
                                    (fun uu____10860 ->
                                       fun neg_cond ->
                                         fun uu____10862 ->
                                           match (uu____10860, uu____10862)
                                           with
                                           | ((g, eff_label, uu____10922,
                                               cthen),
                                              (uu____10924, celse, g_comp1))
                                               ->
                                               let uu____10971 =
                                                 let uu____10976 =
                                                   maybe_return eff_label
                                                     cthen in
                                                 FStar_TypeChecker_Common.lcomp_comp
                                                   uu____10976 in
                                               (match uu____10971 with
                                                | (cthen1, g_then) ->
                                                    let uu____10987 =
                                                      let uu____10998 =
                                                        lift_comps_sep_guards
                                                          env cthen1 celse
                                                          FStar_Pervasives_Native.None
                                                          false in
                                                      match uu____10998 with
                                                      | (m, cthen2, celse1,
                                                         g_lift_then,
                                                         g_lift_else) ->
                                                          let md1 =
                                                            FStar_TypeChecker_Env.get_effect_decl
                                                              env m in
                                                          let uu____11026 =
                                                            FStar_All.pipe_right
                                                              cthen2
                                                              FStar_Syntax_Util.comp_to_comp_typ in
                                                          let uu____11027 =
                                                            FStar_All.pipe_right
                                                              celse1
                                                              FStar_Syntax_Util.comp_to_comp_typ in
                                                          (md1, uu____11026,
                                                            uu____11027,
                                                            g_lift_then,
                                                            g_lift_else) in
                                                    (match uu____10987 with
                                                     | (md1, ct_then,
                                                        ct_else, g_lift_then,
                                                        g_lift_else) ->
                                                         let fn =
                                                           let uu____11078 =
                                                             FStar_All.pipe_right
                                                               md1
                                                               FStar_Syntax_Util.is_layered in
                                                           if uu____11078
                                                           then
                                                             mk_layered_conjunction
                                                           else
                                                             mk_non_layered_conjunction in
                                                         let uu____11112 =
                                                           let uu____11117 =
                                                             FStar_TypeChecker_Env.get_range
                                                               env in
                                                           fn env md1 u_res_t
                                                             res_t g ct_then
                                                             ct_else
                                                             uu____11117 in
                                                         (match uu____11112
                                                          with
                                                          | (c,
                                                             g_conjunction)
                                                              ->
                                                              let g_then1 =
                                                                let uu____11129
                                                                  =
                                                                  FStar_TypeChecker_Env.conj_guard
                                                                    g_then
                                                                    g_lift_then in
                                                                let uu____11130
                                                                  =
                                                                  FStar_Syntax_Util.mk_conj
                                                                    neg_cond
                                                                    g in
                                                                FStar_TypeChecker_Common.weaken_guard_formula
                                                                  uu____11129
                                                                  uu____11130 in
                                                              let g_else =
                                                                let uu____11132
                                                                  =
                                                                  let uu____11133
                                                                    =
                                                                    FStar_Syntax_Util.mk_neg
                                                                    g in
                                                                  FStar_Syntax_Util.mk_conj
                                                                    neg_cond
                                                                    uu____11133 in
                                                                FStar_TypeChecker_Common.weaken_guard_formula
                                                                  g_lift_else
                                                                  uu____11132 in
                                                              let uu____11136
                                                                =
                                                                FStar_TypeChecker_Env.conj_guards
                                                                  [g_comp1;
                                                                  g_then1;
                                                                  g_else;
                                                                  g_conjunction] in
                                                              ((FStar_Pervasives_Native.Some
                                                                  md1), c,
                                                                uu____11136)))))
                                    lcases1 neg_branch_conds1
                                    ((FStar_Pervasives_Native.Some md), comp,
                                      g_comp)) in
                       (match uu____9835 with
                        | (md, comp, g_comp) ->
                            let uu____11152 =
                              let uu____11157 =
                                let check =
                                  FStar_Syntax_Util.mk_imp
                                    exhaustiveness_branch_cond
                                    FStar_Syntax_Util.t_false in
                                let check1 =
                                  let uu____11164 =
                                    FStar_TypeChecker_Env.get_range env in
                                  label
                                    FStar_TypeChecker_Err.exhaustiveness_check
                                    uu____11164 check in
                                strengthen_comp env
                                  FStar_Pervasives_Native.None comp check1
                                  bind_cases_flags in
                              match uu____11157 with
                              | (c, g) ->
                                  let uu____11175 =
                                    FStar_TypeChecker_Env.conj_guard g_comp g in
                                  (c, uu____11175) in
                            (match uu____11152 with
                             | (comp1, g_comp1) ->
                                 let g_comp2 =
                                   let uu____11183 =
                                     let uu____11184 =
                                       FStar_All.pipe_right scrutinee
                                         FStar_Syntax_Syntax.mk_binder in
                                     [uu____11184] in
                                   FStar_TypeChecker_Env.close_guard env0
                                     uu____11183 g_comp1 in
                                 (match lcases with
                                  | [] -> (comp1, g_comp2)
                                  | uu____11227::[] -> (comp1, g_comp2)
                                  | uu____11270 ->
                                      let uu____11287 =
                                        let uu____11289 =
                                          FStar_All.pipe_right md
                                            FStar_Util.must in
                                        FStar_All.pipe_right uu____11289
                                          FStar_Syntax_Util.is_layered in
                                      if uu____11287
                                      then (comp1, g_comp2)
                                      else
                                        (let comp2 =
                                           FStar_TypeChecker_Env.comp_to_comp_typ
                                             env comp1 in
                                         let md1 =
                                           FStar_TypeChecker_Env.get_effect_decl
                                             env
                                             comp2.FStar_Syntax_Syntax.effect_name in
                                         let uu____11302 =
                                           destruct_wp_comp comp2 in
                                         match uu____11302 with
                                         | (uu____11313, uu____11314, wp) ->
                                             let ite_wp =
                                               let uu____11317 =
                                                 FStar_All.pipe_right md1
                                                   FStar_Syntax_Util.get_wp_ite_combinator in
                                               FStar_All.pipe_right
                                                 uu____11317 FStar_Util.must in
                                             let wp1 =
                                               let uu____11325 =
                                                 FStar_TypeChecker_Env.inst_effect_fun_with
                                                   [u_res_t] env md1 ite_wp in
                                               let uu____11326 =
                                                 let uu____11327 =
                                                   FStar_Syntax_Syntax.as_arg
                                                     res_t in
                                                 let uu____11336 =
                                                   let uu____11347 =
                                                     FStar_Syntax_Syntax.as_arg
                                                       wp in
                                                   [uu____11347] in
                                                 uu____11327 :: uu____11336 in
                                               FStar_Syntax_Syntax.mk_Tm_app
                                                 uu____11325 uu____11326
                                                 wp.FStar_Syntax_Syntax.pos in
                                             let uu____11380 =
                                               mk_comp md1 u_res_t res_t wp1
                                                 bind_cases_flags in
                                             (uu____11380, g_comp2)))))) in
              FStar_TypeChecker_Common.mk_lcomp eff res_t bind_cases_flags
                bind_cases
let (check_comp :
  FStar_TypeChecker_Env.env ->
    FStar_Syntax_Syntax.term ->
      FStar_Syntax_Syntax.comp ->
        FStar_Syntax_Syntax.comp ->
          (FStar_Syntax_Syntax.term * FStar_Syntax_Syntax.comp *
            FStar_TypeChecker_Common.guard_t))
  =
  fun env ->
    fun e ->
      fun c ->
        fun c' ->
          let uu____11415 = FStar_TypeChecker_Rel.sub_comp env c c' in
          match uu____11415 with
          | FStar_Pervasives_Native.None ->
              if env.FStar_TypeChecker_Env.use_eq
              then
                let uu____11431 =
                  FStar_TypeChecker_Err.computed_computation_type_does_not_match_annotation_eq
                    env e c c' in
                let uu____11437 = FStar_TypeChecker_Env.get_range env in
                FStar_Errors.raise_error uu____11431 uu____11437
              else
                (let uu____11446 =
                   FStar_TypeChecker_Err.computed_computation_type_does_not_match_annotation
                     env e c c' in
                 let uu____11452 = FStar_TypeChecker_Env.get_range env in
                 FStar_Errors.raise_error uu____11446 uu____11452)
          | FStar_Pervasives_Native.Some g -> (e, c', g)
let (universe_of_comp :
  FStar_TypeChecker_Env.env ->
    FStar_Syntax_Syntax.universe ->
      FStar_Syntax_Syntax.comp -> FStar_Syntax_Syntax.universe)
  =
  fun env ->
    fun u_res ->
      fun c ->
        let c_lid =
          let uu____11477 =
            FStar_All.pipe_right c FStar_Syntax_Util.comp_effect_name in
          FStar_All.pipe_right uu____11477
            (FStar_TypeChecker_Env.norm_eff_name env) in
        let uu____11480 = FStar_Syntax_Util.is_pure_or_ghost_effect c_lid in
        if uu____11480
        then u_res
        else
          (let is_total =
             let uu____11487 =
               FStar_TypeChecker_Env.lookup_effect_quals env c_lid in
             FStar_All.pipe_right uu____11487
               (FStar_List.existsb
                  (fun q -> q = FStar_Syntax_Syntax.TotalEffect)) in
           if Prims.op_Negation is_total
           then FStar_Syntax_Syntax.U_zero
           else
             (let uu____11498 = FStar_TypeChecker_Env.effect_repr env c u_res in
              match uu____11498 with
              | FStar_Pervasives_Native.None ->
                  let uu____11501 =
                    let uu____11507 =
                      let uu____11509 =
                        FStar_Syntax_Print.lid_to_string c_lid in
                      FStar_Util.format1
                        "Effect %s is marked total but does not have a repr"
                        uu____11509 in
                    (FStar_Errors.Fatal_EffectCannotBeReified, uu____11507) in
                  FStar_Errors.raise_error uu____11501
                    c.FStar_Syntax_Syntax.pos
              | FStar_Pervasives_Native.Some tm ->
                  env.FStar_TypeChecker_Env.universe_of env tm))
let (check_trivial_precondition :
  FStar_TypeChecker_Env.env ->
    FStar_Syntax_Syntax.comp ->
      (FStar_Syntax_Syntax.comp_typ * FStar_Syntax_Syntax.formula *
        FStar_TypeChecker_Common.guard_t))
  =
  fun env ->
    fun c ->
      let ct =
        FStar_All.pipe_right c
          (FStar_TypeChecker_Env.unfold_effect_abbrev env) in
      let md =
        FStar_TypeChecker_Env.get_effect_decl env
          ct.FStar_Syntax_Syntax.effect_name in
      let uu____11533 = destruct_wp_comp ct in
      match uu____11533 with
      | (u_t, t, wp) ->
          let vc =
            let uu____11550 =
              let uu____11551 =
                let uu____11552 =
                  FStar_All.pipe_right md
                    FStar_Syntax_Util.get_wp_trivial_combinator in
                FStar_All.pipe_right uu____11552 FStar_Util.must in
              FStar_TypeChecker_Env.inst_effect_fun_with [u_t] env md
                uu____11551 in
            let uu____11559 =
              let uu____11560 = FStar_Syntax_Syntax.as_arg t in
              let uu____11569 =
                let uu____11580 = FStar_Syntax_Syntax.as_arg wp in
                [uu____11580] in
              uu____11560 :: uu____11569 in
            let uu____11613 = FStar_TypeChecker_Env.get_range env in
            FStar_Syntax_Syntax.mk_Tm_app uu____11550 uu____11559 uu____11613 in
          let uu____11614 =
            FStar_All.pipe_left FStar_TypeChecker_Env.guard_of_guard_formula
              (FStar_TypeChecker_Common.NonTrivial vc) in
          (ct, vc, uu____11614)
let (coerce_with :
  FStar_TypeChecker_Env.env ->
    FStar_Syntax_Syntax.term ->
      FStar_TypeChecker_Common.lcomp ->
        FStar_Syntax_Syntax.typ ->
          FStar_Ident.lident ->
            FStar_Syntax_Syntax.universes ->
              FStar_Syntax_Syntax.args ->
                (FStar_Syntax_Syntax.term -> FStar_Syntax_Syntax.comp) ->
                  (FStar_Syntax_Syntax.term * FStar_TypeChecker_Common.lcomp))
  =
  fun env ->
    fun e ->
      fun lc ->
        fun ty ->
          fun f ->
            fun us ->
              fun eargs ->
                fun mkcomp ->
                  let uu____11669 =
                    FStar_TypeChecker_Env.try_lookup_lid env f in
                  match uu____11669 with
                  | FStar_Pervasives_Native.Some uu____11684 ->
                      ((let uu____11702 =
                          FStar_TypeChecker_Env.debug env
                            (FStar_Options.Other "Coercions") in
                        if uu____11702
                        then
                          let uu____11706 = FStar_Ident.string_of_lid f in
                          FStar_Util.print1 "Coercing with %s!\n" uu____11706
                        else ());
                       (let coercion =
                          let uu____11712 =
                            FStar_Ident.set_lid_range f
                              e.FStar_Syntax_Syntax.pos in
                          FStar_Syntax_Syntax.fvar uu____11712
                            (FStar_Syntax_Syntax.Delta_constant_at_level
                               Prims.int_one) FStar_Pervasives_Native.None in
                        let coercion1 =
                          FStar_Syntax_Syntax.mk_Tm_uinst coercion us in
                        let coercion2 =
                          FStar_Syntax_Util.mk_app coercion1 eargs in
                        let lc1 =
                          let uu____11719 =
                            let uu____11720 =
                              let uu____11721 = mkcomp ty in
                              FStar_All.pipe_left
                                FStar_TypeChecker_Common.lcomp_of_comp
                                uu____11721 in
                            (FStar_Pervasives_Native.None, uu____11720) in
                          bind e.FStar_Syntax_Syntax.pos env
                            (FStar_Pervasives_Native.Some e) lc uu____11719 in
                        let e1 =
                          let uu____11725 =
                            let uu____11726 = FStar_Syntax_Syntax.as_arg e in
                            [uu____11726] in
                          FStar_Syntax_Syntax.mk_Tm_app coercion2 uu____11725
                            e.FStar_Syntax_Syntax.pos in
                        (e1, lc1)))
                  | FStar_Pervasives_Native.None ->
                      ((let uu____11760 =
                          let uu____11766 =
                            let uu____11768 = FStar_Ident.string_of_lid f in
                            FStar_Util.format1
                              "Coercion %s was not found in the environment, not coercing."
                              uu____11768 in
                          (FStar_Errors.Warning_CoercionNotFound,
                            uu____11766) in
                        FStar_Errors.log_issue e.FStar_Syntax_Syntax.pos
                          uu____11760);
                       (e, lc))
type isErased =
  | Yes of FStar_Syntax_Syntax.term 
  | Maybe 
  | No 
let (uu___is_Yes : isErased -> Prims.bool) =
  fun projectee ->
    match projectee with | Yes _0 -> true | uu____11787 -> false
let (__proj__Yes__item___0 : isErased -> FStar_Syntax_Syntax.term) =
  fun projectee -> match projectee with | Yes _0 -> _0
let (uu___is_Maybe : isErased -> Prims.bool) =
  fun projectee ->
    match projectee with | Maybe -> true | uu____11805 -> false
let (uu___is_No : isErased -> Prims.bool) =
  fun projectee -> match projectee with | No -> true | uu____11816 -> false
let rec (check_erased :
  FStar_TypeChecker_Env.env -> FStar_Syntax_Syntax.term -> isErased) =
  fun env ->
    fun t ->
      let norm' =
        FStar_TypeChecker_Normalize.normalize
          [FStar_TypeChecker_Env.Beta;
          FStar_TypeChecker_Env.Eager_unfolding;
          FStar_TypeChecker_Env.UnfoldUntil
            FStar_Syntax_Syntax.delta_constant;
          FStar_TypeChecker_Env.Exclude FStar_TypeChecker_Env.Zeta;
          FStar_TypeChecker_Env.Primops;
          FStar_TypeChecker_Env.Weak;
          FStar_TypeChecker_Env.HNF;
          FStar_TypeChecker_Env.Iota] in
      let t1 = norm' env t in
      let t2 = FStar_Syntax_Util.unrefine t1 in
      let uu____11840 = FStar_Syntax_Util.head_and_args t2 in
      match uu____11840 with
      | (h, args) ->
          let h1 = FStar_Syntax_Util.un_uinst h in
          let r =
            let uu____11885 =
              let uu____11900 =
                let uu____11901 = FStar_Syntax_Subst.compress h1 in
                uu____11901.FStar_Syntax_Syntax.n in
              (uu____11900, args) in
            match uu____11885 with
            | (FStar_Syntax_Syntax.Tm_fvar fv,
               (a, FStar_Pervasives_Native.None)::[]) when
                FStar_Syntax_Syntax.fv_eq_lid fv
                  FStar_Parser_Const.erased_lid
                -> Yes a
            | (FStar_Syntax_Syntax.Tm_uvar uu____11948, uu____11949) -> Maybe
            | (FStar_Syntax_Syntax.Tm_unknown, uu____11982) -> Maybe
            | (FStar_Syntax_Syntax.Tm_match (uu____12003, branches),
               uu____12005) ->
                FStar_All.pipe_right branches
                  (FStar_List.fold_left
                     (fun acc ->
                        fun br ->
                          match acc with
                          | Yes uu____12069 -> Maybe
                          | Maybe -> Maybe
                          | No ->
                              let uu____12070 =
                                FStar_Syntax_Subst.open_branch br in
                              (match uu____12070 with
                               | (uu____12071, uu____12072, br_body) ->
                                   let uu____12090 =
                                     let uu____12091 =
                                       let uu____12096 =
                                         let uu____12097 =
                                           let uu____12100 =
                                             FStar_All.pipe_right br_body
                                               FStar_Syntax_Free.names in
                                           FStar_All.pipe_right uu____12100
                                             FStar_Util.set_elements in
                                         FStar_All.pipe_right uu____12097
                                           (FStar_TypeChecker_Env.push_bvs
                                              env) in
                                       check_erased uu____12096 in
                                     FStar_All.pipe_right br_body uu____12091 in
                                   (match uu____12090 with
                                    | No -> No
                                    | uu____12111 -> Maybe))) No)
            | uu____12112 -> No in
          r
let (maybe_coerce_lc :
  FStar_TypeChecker_Env.env ->
    FStar_Syntax_Syntax.term ->
      FStar_TypeChecker_Common.lcomp ->
        FStar_Syntax_Syntax.typ ->
          (FStar_Syntax_Syntax.term * FStar_TypeChecker_Common.lcomp *
            FStar_TypeChecker_Common.guard_t))
  =
  fun env ->
    fun e ->
      fun lc ->
        fun exp_t ->
          let should_coerce =
            (((let uu____12164 = FStar_Options.use_two_phase_tc () in
               Prims.op_Negation uu____12164) ||
                env.FStar_TypeChecker_Env.phase1)
               || env.FStar_TypeChecker_Env.lax)
              || (FStar_Options.lax ()) in
          if Prims.op_Negation should_coerce
          then (e, lc, FStar_TypeChecker_Env.trivial_guard)
          else
            (let is_t_term t =
               let t1 = FStar_TypeChecker_Normalize.unfold_whnf env t in
               let uu____12183 =
                 let uu____12184 = FStar_Syntax_Subst.compress t1 in
                 uu____12184.FStar_Syntax_Syntax.n in
               match uu____12183 with
               | FStar_Syntax_Syntax.Tm_fvar fv ->
                   FStar_Syntax_Syntax.fv_eq_lid fv
                     FStar_Parser_Const.term_lid
               | uu____12189 -> false in
             let is_t_term_view t =
               let t1 = FStar_TypeChecker_Normalize.unfold_whnf env t in
               let uu____12199 =
                 let uu____12200 = FStar_Syntax_Subst.compress t1 in
                 uu____12200.FStar_Syntax_Syntax.n in
               match uu____12199 with
               | FStar_Syntax_Syntax.Tm_fvar fv ->
                   FStar_Syntax_Syntax.fv_eq_lid fv
                     FStar_Parser_Const.term_view_lid
               | uu____12205 -> false in
             let is_type t =
               let t1 = FStar_TypeChecker_Normalize.unfold_whnf env t in
               let t2 = FStar_Syntax_Util.unrefine t1 in
               let uu____12216 =
                 let uu____12217 = FStar_Syntax_Subst.compress t2 in
                 uu____12217.FStar_Syntax_Syntax.n in
               match uu____12216 with
               | FStar_Syntax_Syntax.Tm_type uu____12221 -> true
               | uu____12223 -> false in
             let res_typ =
               FStar_Syntax_Util.unrefine lc.FStar_TypeChecker_Common.res_typ in
             let uu____12226 = FStar_Syntax_Util.head_and_args res_typ in
             match uu____12226 with
             | (head, args) ->
                 ((let uu____12276 =
                     FStar_TypeChecker_Env.debug env
                       (FStar_Options.Other "Coercions") in
                   if uu____12276
                   then
                     let uu____12280 =
                       FStar_Range.string_of_range e.FStar_Syntax_Syntax.pos in
                     let uu____12282 = FStar_Syntax_Print.term_to_string e in
                     let uu____12284 =
                       FStar_Syntax_Print.term_to_string res_typ in
                     let uu____12286 =
                       FStar_Syntax_Print.term_to_string exp_t in
                     FStar_Util.print4
                       "(%s) Trying to coerce %s from type (%s) to type (%s)\n"
                       uu____12280 uu____12282 uu____12284 uu____12286
                   else ());
                  (let mk_erased u t =
                     let uu____12304 =
                       let uu____12307 =
                         fvar_const env FStar_Parser_Const.erased_lid in
                       FStar_Syntax_Syntax.mk_Tm_uinst uu____12307 [u] in
                     let uu____12308 =
                       let uu____12319 = FStar_Syntax_Syntax.as_arg t in
                       [uu____12319] in
                     FStar_Syntax_Util.mk_app uu____12304 uu____12308 in
                   let uu____12344 =
                     let uu____12359 =
                       let uu____12360 = FStar_Syntax_Util.un_uinst head in
                       uu____12360.FStar_Syntax_Syntax.n in
                     (uu____12359, args) in
                   match uu____12344 with
                   | (FStar_Syntax_Syntax.Tm_fvar fv, []) when
                       (FStar_Syntax_Syntax.fv_eq_lid fv
                          FStar_Parser_Const.bool_lid)
                         && (is_type exp_t)
                       ->
                       let uu____12398 =
                         coerce_with env e lc FStar_Syntax_Util.ktype0
                           FStar_Parser_Const.b2t_lid [] []
                           FStar_Syntax_Syntax.mk_Total in
                       (match uu____12398 with
                        | (e1, lc1) ->
                            (e1, lc1, FStar_TypeChecker_Env.trivial_guard))
                   | (FStar_Syntax_Syntax.Tm_fvar fv, []) when
                       (FStar_Syntax_Syntax.fv_eq_lid fv
                          FStar_Parser_Const.term_lid)
                         && (is_t_term_view exp_t)
                       ->
                       let uu____12438 =
                         coerce_with env e lc FStar_Syntax_Syntax.t_term_view
                           FStar_Parser_Const.inspect [] []
                           FStar_Syntax_Syntax.mk_Tac in
                       (match uu____12438 with
                        | (e1, lc1) ->
                            (e1, lc1, FStar_TypeChecker_Env.trivial_guard))
                   | (FStar_Syntax_Syntax.Tm_fvar fv, []) when
                       (FStar_Syntax_Syntax.fv_eq_lid fv
                          FStar_Parser_Const.term_view_lid)
                         && (is_t_term exp_t)
                       ->
                       let uu____12478 =
                         coerce_with env e lc FStar_Syntax_Syntax.t_term
                           FStar_Parser_Const.pack [] []
                           FStar_Syntax_Syntax.mk_Tac in
                       (match uu____12478 with
                        | (e1, lc1) ->
                            (e1, lc1, FStar_TypeChecker_Env.trivial_guard))
                   | (FStar_Syntax_Syntax.Tm_fvar fv, []) when
                       (FStar_Syntax_Syntax.fv_eq_lid fv
                          FStar_Parser_Const.binder_lid)
                         && (is_t_term exp_t)
                       ->
                       let uu____12518 =
                         coerce_with env e lc FStar_Syntax_Syntax.t_term
                           FStar_Parser_Const.binder_to_term [] []
                           FStar_Syntax_Syntax.mk_Tac in
                       (match uu____12518 with
                        | (e1, lc1) ->
                            (e1, lc1, FStar_TypeChecker_Env.trivial_guard))
                   | uu____12539 ->
                       let uu____12554 =
                         let uu____12559 = check_erased env res_typ in
                         let uu____12560 = check_erased env exp_t in
                         (uu____12559, uu____12560) in
                       (match uu____12554 with
                        | (No, Yes ty) ->
                            let u =
                              env.FStar_TypeChecker_Env.universe_of env ty in
                            let uu____12569 =
                              FStar_TypeChecker_Rel.get_subtyping_predicate
                                env res_typ ty in
                            (match uu____12569 with
                             | FStar_Pervasives_Native.None ->
                                 (e, lc, FStar_TypeChecker_Env.trivial_guard)
                             | FStar_Pervasives_Native.Some g ->
                                 let g1 =
                                   FStar_TypeChecker_Env.apply_guard g e in
                                 let uu____12580 =
                                   let uu____12585 =
                                     let uu____12586 =
                                       FStar_Syntax_Syntax.iarg ty in
                                     [uu____12586] in
                                   coerce_with env e lc exp_t
                                     FStar_Parser_Const.hide [u] uu____12585
                                     FStar_Syntax_Syntax.mk_Total in
                                 (match uu____12580 with
                                  | (e1, lc1) -> (e1, lc1, g1)))
                        | (Yes ty, No) ->
                            let u =
                              env.FStar_TypeChecker_Env.universe_of env ty in
                            let uu____12621 =
                              let uu____12626 =
                                let uu____12627 = FStar_Syntax_Syntax.iarg ty in
                                [uu____12627] in
                              coerce_with env e lc ty
                                FStar_Parser_Const.reveal [u] uu____12626
                                FStar_Syntax_Syntax.mk_GTotal in
                            (match uu____12621 with
                             | (e1, lc1) ->
                                 (e1, lc1,
                                   FStar_TypeChecker_Env.trivial_guard))
                        | uu____12660 ->
                            (e, lc, FStar_TypeChecker_Env.trivial_guard)))))
let (coerce_views :
  FStar_TypeChecker_Env.env ->
    FStar_Syntax_Syntax.term ->
      FStar_TypeChecker_Common.lcomp ->
        (FStar_Syntax_Syntax.term * FStar_TypeChecker_Common.lcomp)
          FStar_Pervasives_Native.option)
  =
  fun env ->
    fun e ->
      fun lc ->
        let rt = lc.FStar_TypeChecker_Common.res_typ in
        let rt1 = FStar_Syntax_Util.unrefine rt in
        let uu____12695 = FStar_Syntax_Util.head_and_args rt1 in
        match uu____12695 with
        | (hd, args) ->
            let uu____12744 =
              let uu____12759 =
                let uu____12760 = FStar_Syntax_Subst.compress hd in
                uu____12760.FStar_Syntax_Syntax.n in
              (uu____12759, args) in
            (match uu____12744 with
             | (FStar_Syntax_Syntax.Tm_fvar fv, []) when
                 FStar_Syntax_Syntax.fv_eq_lid fv FStar_Parser_Const.term_lid
                 ->
                 let uu____12798 =
                   coerce_with env e lc FStar_Syntax_Syntax.t_term_view
                     FStar_Parser_Const.inspect [] []
                     FStar_Syntax_Syntax.mk_Tac in
                 FStar_All.pipe_left
                   (fun uu____12825 ->
                      FStar_Pervasives_Native.Some uu____12825) uu____12798
             | uu____12826 -> FStar_Pervasives_Native.None)
let (weaken_result_typ :
  FStar_TypeChecker_Env.env ->
    FStar_Syntax_Syntax.term ->
      FStar_TypeChecker_Common.lcomp ->
        FStar_Syntax_Syntax.typ ->
          (FStar_Syntax_Syntax.term * FStar_TypeChecker_Common.lcomp *
            FStar_TypeChecker_Common.guard_t))
  =
  fun env ->
    fun e ->
      fun lc ->
        fun t ->
          (let uu____12879 =
             FStar_TypeChecker_Env.debug env FStar_Options.High in
           if uu____12879
           then
             let uu____12882 = FStar_Syntax_Print.term_to_string e in
             let uu____12884 = FStar_TypeChecker_Common.lcomp_to_string lc in
             let uu____12886 = FStar_Syntax_Print.term_to_string t in
             FStar_Util.print3 "weaken_result_typ e=(%s) lc=(%s) t=(%s)\n"
               uu____12882 uu____12884 uu____12886
           else ());
          (let use_eq =
             (env.FStar_TypeChecker_Env.use_eq_strict ||
                env.FStar_TypeChecker_Env.use_eq)
               ||
               (let uu____12896 =
                  FStar_TypeChecker_Env.effect_decl_opt env
                    lc.FStar_TypeChecker_Common.eff_name in
                match uu____12896 with
                | FStar_Pervasives_Native.Some (ed, qualifiers) ->
                    FStar_All.pipe_right qualifiers
                      (FStar_List.contains FStar_Syntax_Syntax.Reifiable)
                | uu____12921 -> false) in
           let gopt =
             if use_eq
             then
               let uu____12947 =
                 FStar_TypeChecker_Rel.try_teq true env
                   lc.FStar_TypeChecker_Common.res_typ t in
               (uu____12947, false)
             else
               (let uu____12957 =
                  FStar_TypeChecker_Rel.get_subtyping_predicate env
                    lc.FStar_TypeChecker_Common.res_typ t in
                (uu____12957, true)) in
           match gopt with
           | (FStar_Pervasives_Native.None, uu____12970) ->
               if env.FStar_TypeChecker_Env.failhard
               then
                 let uu____12982 =
                   FStar_TypeChecker_Err.basic_type_error env
                     (FStar_Pervasives_Native.Some e) t
                     lc.FStar_TypeChecker_Common.res_typ in
                 FStar_Errors.raise_error uu____12982
                   e.FStar_Syntax_Syntax.pos
               else
                 (FStar_TypeChecker_Rel.subtype_fail env e
                    lc.FStar_TypeChecker_Common.res_typ t;
                  (e,
                    ((let uu___1463_12998 = lc in
                      {
                        FStar_TypeChecker_Common.eff_name =
                          (uu___1463_12998.FStar_TypeChecker_Common.eff_name);
                        FStar_TypeChecker_Common.res_typ = t;
                        FStar_TypeChecker_Common.cflags =
                          (uu___1463_12998.FStar_TypeChecker_Common.cflags);
                        FStar_TypeChecker_Common.comp_thunk =
                          (uu___1463_12998.FStar_TypeChecker_Common.comp_thunk)
                      })), FStar_TypeChecker_Env.trivial_guard))
           | (FStar_Pervasives_Native.Some g, apply_guard) ->
               let uu____13005 = FStar_TypeChecker_Env.guard_form g in
               (match uu____13005 with
                | FStar_TypeChecker_Common.Trivial ->
                    let strengthen_trivial uu____13021 =
                      let uu____13022 =
                        FStar_TypeChecker_Common.lcomp_comp lc in
                      match uu____13022 with
                      | (c, g_c) ->
                          let res_t = FStar_Syntax_Util.comp_result c in
                          let set_result_typ c1 =
                            FStar_Syntax_Util.set_result_typ c1 t in
                          let uu____13042 =
                            let uu____13044 = FStar_Syntax_Util.eq_tm t res_t in
                            uu____13044 = FStar_Syntax_Util.Equal in
                          if uu____13042
                          then
                            ((let uu____13051 =
                                FStar_All.pipe_left
                                  (FStar_TypeChecker_Env.debug env)
                                  FStar_Options.Extreme in
                              if uu____13051
                              then
                                let uu____13055 =
                                  FStar_Syntax_Print.term_to_string res_t in
                                let uu____13057 =
                                  FStar_Syntax_Print.term_to_string t in
                                FStar_Util.print2
                                  "weaken_result_type::strengthen_trivial: res_t:%s is same as t:%s\n"
                                  uu____13055 uu____13057
                              else ());
                             (let uu____13062 = set_result_typ c in
                              (uu____13062, g_c)))
                          else
                            (let is_res_t_refinement =
                               let res_t1 =
                                 FStar_TypeChecker_Normalize.normalize_refinement
                                   FStar_TypeChecker_Normalize.whnf_steps env
                                   res_t in
                               match res_t1.FStar_Syntax_Syntax.n with
                               | FStar_Syntax_Syntax.Tm_refine uu____13069 ->
                                   true
                               | uu____13077 -> false in
                             if is_res_t_refinement
                             then
                               let x =
                                 FStar_Syntax_Syntax.new_bv
                                   (FStar_Pervasives_Native.Some
                                      (res_t.FStar_Syntax_Syntax.pos)) res_t in
                               let uu____13085 =
                                 let uu____13090 =
                                   let uu____13091 =
                                     FStar_All.pipe_right c
                                       FStar_Syntax_Util.comp_effect_name in
                                   FStar_All.pipe_right uu____13091
                                     (FStar_TypeChecker_Env.norm_eff_name env) in
                                 let uu____13094 =
                                   FStar_Syntax_Syntax.bv_to_name x in
                                 return_value env uu____13090
                                   (comp_univ_opt c) res_t uu____13094 in
                               match uu____13085 with
                               | (cret, gret) ->
                                   let lc1 =
                                     let uu____13104 =
                                       FStar_TypeChecker_Common.lcomp_of_comp
                                         c in
                                     let uu____13105 =
                                       let uu____13106 =
                                         FStar_TypeChecker_Common.lcomp_of_comp
                                           cret in
                                       ((FStar_Pervasives_Native.Some x),
                                         uu____13106) in
                                     bind e.FStar_Syntax_Syntax.pos env
                                       (FStar_Pervasives_Native.Some e)
                                       uu____13104 uu____13105 in
                                   ((let uu____13110 =
                                       FStar_All.pipe_left
                                         (FStar_TypeChecker_Env.debug env)
                                         FStar_Options.Extreme in
                                     if uu____13110
                                     then
                                       let uu____13114 =
                                         FStar_Syntax_Print.term_to_string e in
                                       let uu____13116 =
                                         FStar_Syntax_Print.comp_to_string c in
                                       let uu____13118 =
                                         FStar_Syntax_Print.term_to_string t in
                                       let uu____13120 =
                                         FStar_TypeChecker_Common.lcomp_to_string
                                           lc1 in
                                       FStar_Util.print4
                                         "weaken_result_type::strengthen_trivial: inserting a return for e: %s, c: %s, t: %s, and then post return lc: %s\n"
                                         uu____13114 uu____13116 uu____13118
                                         uu____13120
                                     else ());
                                    (let uu____13125 =
                                       FStar_TypeChecker_Common.lcomp_comp
                                         lc1 in
                                     match uu____13125 with
                                     | (c1, g_lc) ->
                                         let uu____13136 = set_result_typ c1 in
                                         let uu____13137 =
                                           FStar_TypeChecker_Env.conj_guards
                                             [g_c; gret; g_lc] in
                                         (uu____13136, uu____13137)))
                             else
                               ((let uu____13141 =
                                   FStar_All.pipe_left
                                     (FStar_TypeChecker_Env.debug env)
                                     FStar_Options.Extreme in
                                 if uu____13141
                                 then
                                   let uu____13145 =
                                     FStar_Syntax_Print.term_to_string res_t in
                                   let uu____13147 =
                                     FStar_Syntax_Print.comp_to_string c in
                                   FStar_Util.print2
                                     "weaken_result_type::strengthen_trivial: res_t:%s is not a refinement, leaving c:%s as is\n"
                                     uu____13145 uu____13147
                                 else ());
                                (let uu____13152 = set_result_typ c in
                                 (uu____13152, g_c)))) in
                    let lc1 =
                      FStar_TypeChecker_Common.mk_lcomp
                        lc.FStar_TypeChecker_Common.eff_name t
                        lc.FStar_TypeChecker_Common.cflags strengthen_trivial in
                    (e, lc1, g)
                | FStar_TypeChecker_Common.NonTrivial f ->
                    let g1 =
                      let uu___1502_13156 = g in
                      {
                        FStar_TypeChecker_Common.guard_f =
                          FStar_TypeChecker_Common.Trivial;
                        FStar_TypeChecker_Common.deferred_to_tac =
                          (uu___1502_13156.FStar_TypeChecker_Common.deferred_to_tac);
                        FStar_TypeChecker_Common.deferred =
                          (uu___1502_13156.FStar_TypeChecker_Common.deferred);
                        FStar_TypeChecker_Common.univ_ineqs =
                          (uu___1502_13156.FStar_TypeChecker_Common.univ_ineqs);
                        FStar_TypeChecker_Common.implicits =
                          (uu___1502_13156.FStar_TypeChecker_Common.implicits)
                      } in
                    let strengthen uu____13166 =
                      let uu____13167 =
                        env.FStar_TypeChecker_Env.lax &&
                          (FStar_Options.ml_ish ()) in
                      if uu____13167
                      then FStar_TypeChecker_Common.lcomp_comp lc
                      else
                        (let f1 =
                           FStar_TypeChecker_Normalize.normalize
                             [FStar_TypeChecker_Env.Beta;
                             FStar_TypeChecker_Env.Eager_unfolding;
                             FStar_TypeChecker_Env.Simplify;
                             FStar_TypeChecker_Env.Primops] env f in
                         let uu____13177 =
                           let uu____13178 = FStar_Syntax_Subst.compress f1 in
                           uu____13178.FStar_Syntax_Syntax.n in
                         match uu____13177 with
                         | FStar_Syntax_Syntax.Tm_abs
                             (uu____13185,
                              {
                                FStar_Syntax_Syntax.n =
                                  FStar_Syntax_Syntax.Tm_fvar fv;
                                FStar_Syntax_Syntax.pos = uu____13187;
                                FStar_Syntax_Syntax.vars = uu____13188;_},
                              uu____13189)
                             when
                             FStar_Syntax_Syntax.fv_eq_lid fv
                               FStar_Parser_Const.true_lid
                             ->
                             let lc1 =
                               let uu___1518_13215 = lc in
                               {
                                 FStar_TypeChecker_Common.eff_name =
                                   (uu___1518_13215.FStar_TypeChecker_Common.eff_name);
                                 FStar_TypeChecker_Common.res_typ = t;
                                 FStar_TypeChecker_Common.cflags =
                                   (uu___1518_13215.FStar_TypeChecker_Common.cflags);
                                 FStar_TypeChecker_Common.comp_thunk =
                                   (uu___1518_13215.FStar_TypeChecker_Common.comp_thunk)
                               } in
                             FStar_TypeChecker_Common.lcomp_comp lc1
                         | uu____13216 ->
                             let uu____13217 =
                               FStar_TypeChecker_Common.lcomp_comp lc in
                             (match uu____13217 with
                              | (c, g_c) ->
                                  ((let uu____13229 =
                                      FStar_All.pipe_left
                                        (FStar_TypeChecker_Env.debug env)
                                        FStar_Options.Extreme in
                                    if uu____13229
                                    then
                                      let uu____13233 =
                                        FStar_TypeChecker_Normalize.term_to_string
                                          env
                                          lc.FStar_TypeChecker_Common.res_typ in
                                      let uu____13235 =
                                        FStar_TypeChecker_Normalize.term_to_string
                                          env t in
                                      let uu____13237 =
                                        FStar_TypeChecker_Normalize.comp_to_string
                                          env c in
                                      let uu____13239 =
                                        FStar_TypeChecker_Normalize.term_to_string
                                          env f1 in
                                      FStar_Util.print4
                                        "Weakened from %s to %s\nStrengthening %s with guard %s\n"
                                        uu____13233 uu____13235 uu____13237
                                        uu____13239
                                    else ());
                                   (let u_t_opt = comp_univ_opt c in
                                    let x =
                                      FStar_Syntax_Syntax.new_bv
                                        (FStar_Pervasives_Native.Some
                                           (t.FStar_Syntax_Syntax.pos)) t in
                                    let xexp =
                                      FStar_Syntax_Syntax.bv_to_name x in
                                    let uu____13249 =
                                      let uu____13254 =
                                        let uu____13255 =
                                          FStar_All.pipe_right c
                                            FStar_Syntax_Util.comp_effect_name in
                                        FStar_All.pipe_right uu____13255
                                          (FStar_TypeChecker_Env.norm_eff_name
                                             env) in
                                      return_value env uu____13254 u_t_opt t
                                        xexp in
                                    match uu____13249 with
                                    | (cret, gret) ->
                                        let guard =
                                          if apply_guard
                                          then
                                            let uu____13266 =
                                              let uu____13267 =
                                                FStar_Syntax_Syntax.as_arg
                                                  xexp in
                                              [uu____13267] in
                                            FStar_Syntax_Syntax.mk_Tm_app f1
                                              uu____13266
                                              f1.FStar_Syntax_Syntax.pos
                                          else f1 in
                                        let uu____13294 =
                                          let uu____13299 =
                                            FStar_All.pipe_left
                                              (fun uu____13320 ->
                                                 FStar_Pervasives_Native.Some
                                                   uu____13320)
                                              (FStar_TypeChecker_Err.subtyping_failed
                                                 env
                                                 lc.FStar_TypeChecker_Common.res_typ
                                                 t) in
                                          let uu____13321 =
                                            let uu____13322 =
                                              FStar_TypeChecker_Env.push_bvs
                                                env [x] in
                                            FStar_TypeChecker_Env.set_range
                                              uu____13322
                                              e.FStar_Syntax_Syntax.pos in
                                          let uu____13323 =
                                            FStar_TypeChecker_Common.lcomp_of_comp
                                              cret in
                                          let uu____13324 =
                                            FStar_All.pipe_left
                                              FStar_TypeChecker_Env.guard_of_guard_formula
                                              (FStar_TypeChecker_Common.NonTrivial
                                                 guard) in
                                          strengthen_precondition uu____13299
                                            uu____13321 e uu____13323
                                            uu____13324 in
                                        (match uu____13294 with
                                         | (eq_ret,
                                            _trivial_so_ok_to_discard) ->
                                             let x1 =
                                               let uu___1538_13332 = x in
                                               {
                                                 FStar_Syntax_Syntax.ppname =
                                                   (uu___1538_13332.FStar_Syntax_Syntax.ppname);
                                                 FStar_Syntax_Syntax.index =
                                                   (uu___1538_13332.FStar_Syntax_Syntax.index);
                                                 FStar_Syntax_Syntax.sort =
                                                   (lc.FStar_TypeChecker_Common.res_typ)
                                               } in
                                             let c1 =
                                               let uu____13334 =
                                                 FStar_TypeChecker_Common.lcomp_of_comp
                                                   c in
                                               bind e.FStar_Syntax_Syntax.pos
                                                 env
                                                 (FStar_Pervasives_Native.Some
                                                    e) uu____13334
                                                 ((FStar_Pervasives_Native.Some
                                                     x1), eq_ret) in
                                             let uu____13337 =
                                               FStar_TypeChecker_Common.lcomp_comp
                                                 c1 in
                                             (match uu____13337 with
                                              | (c2, g_lc) ->
                                                  ((let uu____13349 =
                                                      FStar_All.pipe_left
                                                        (FStar_TypeChecker_Env.debug
                                                           env)
                                                        FStar_Options.Extreme in
                                                    if uu____13349
                                                    then
                                                      let uu____13353 =
                                                        FStar_TypeChecker_Normalize.comp_to_string
                                                          env c2 in
                                                      FStar_Util.print1
                                                        "Strengthened to %s\n"
                                                        uu____13353
                                                    else ());
                                                   (let uu____13358 =
                                                      FStar_TypeChecker_Env.conj_guards
                                                        [g_c; gret; g_lc] in
                                                    (c2, uu____13358))))))))) in
                    let flags =
                      FStar_All.pipe_right lc.FStar_TypeChecker_Common.cflags
                        (FStar_List.collect
                           (fun uu___6_13367 ->
                              match uu___6_13367 with
                              | FStar_Syntax_Syntax.RETURN ->
                                  [FStar_Syntax_Syntax.PARTIAL_RETURN]
                              | FStar_Syntax_Syntax.PARTIAL_RETURN ->
                                  [FStar_Syntax_Syntax.PARTIAL_RETURN]
                              | FStar_Syntax_Syntax.CPS ->
                                  [FStar_Syntax_Syntax.CPS]
                              | uu____13370 -> [])) in
                    let lc1 =
                      let uu____13372 =
                        FStar_TypeChecker_Env.norm_eff_name env
                          lc.FStar_TypeChecker_Common.eff_name in
                      FStar_TypeChecker_Common.mk_lcomp uu____13372 t flags
                        strengthen in
                    let g2 =
                      let uu___1554_13374 = g1 in
                      {
                        FStar_TypeChecker_Common.guard_f =
                          FStar_TypeChecker_Common.Trivial;
                        FStar_TypeChecker_Common.deferred_to_tac =
                          (uu___1554_13374.FStar_TypeChecker_Common.deferred_to_tac);
                        FStar_TypeChecker_Common.deferred =
                          (uu___1554_13374.FStar_TypeChecker_Common.deferred);
                        FStar_TypeChecker_Common.univ_ineqs =
                          (uu___1554_13374.FStar_TypeChecker_Common.univ_ineqs);
                        FStar_TypeChecker_Common.implicits =
                          (uu___1554_13374.FStar_TypeChecker_Common.implicits)
                      } in
                    (e, lc1, g2)))
let (pure_or_ghost_pre_and_post :
  FStar_TypeChecker_Env.env ->
    FStar_Syntax_Syntax.comp ->
      (FStar_Syntax_Syntax.typ FStar_Pervasives_Native.option *
        FStar_Syntax_Syntax.typ))
  =
  fun env ->
    fun comp ->
      let mk_post_type res_t ens =
        let x = FStar_Syntax_Syntax.new_bv FStar_Pervasives_Native.None res_t in
        let uu____13410 =
          let uu____13413 =
            let uu____13414 =
              let uu____13423 = FStar_Syntax_Syntax.bv_to_name x in
              FStar_Syntax_Syntax.as_arg uu____13423 in
            [uu____13414] in
          FStar_Syntax_Syntax.mk_Tm_app ens uu____13413
            res_t.FStar_Syntax_Syntax.pos in
        FStar_Syntax_Util.refine x uu____13410 in
      let norm t =
        FStar_TypeChecker_Normalize.normalize
          [FStar_TypeChecker_Env.Beta;
          FStar_TypeChecker_Env.Eager_unfolding;
          FStar_TypeChecker_Env.EraseUniverses] env t in
      let uu____13446 = FStar_Syntax_Util.is_tot_or_gtot_comp comp in
      if uu____13446
      then
        (FStar_Pervasives_Native.None, (FStar_Syntax_Util.comp_result comp))
      else
        (match comp.FStar_Syntax_Syntax.n with
         | FStar_Syntax_Syntax.GTotal uu____13465 -> failwith "Impossible"
         | FStar_Syntax_Syntax.Total uu____13481 -> failwith "Impossible"
         | FStar_Syntax_Syntax.Comp ct ->
             let uu____13498 =
               (FStar_Ident.lid_equals ct.FStar_Syntax_Syntax.effect_name
                  FStar_Parser_Const.effect_Pure_lid)
                 ||
                 (FStar_Ident.lid_equals ct.FStar_Syntax_Syntax.effect_name
                    FStar_Parser_Const.effect_Ghost_lid) in
             if uu____13498
             then
               (match ct.FStar_Syntax_Syntax.effect_args with
                | (req, uu____13514)::(ens, uu____13516)::uu____13517 ->
                    let uu____13560 =
                      let uu____13563 = norm req in
                      FStar_Pervasives_Native.Some uu____13563 in
                    let uu____13564 =
                      let uu____13565 =
                        mk_post_type ct.FStar_Syntax_Syntax.result_typ ens in
                      FStar_All.pipe_left norm uu____13565 in
                    (uu____13560, uu____13564)
                | uu____13568 ->
                    let uu____13579 =
                      let uu____13585 =
                        let uu____13587 =
                          FStar_Syntax_Print.comp_to_string comp in
                        FStar_Util.format1
                          "Effect constructor is not fully applied; got %s"
                          uu____13587 in
                      (FStar_Errors.Fatal_EffectConstructorNotFullyApplied,
                        uu____13585) in
                    FStar_Errors.raise_error uu____13579
                      comp.FStar_Syntax_Syntax.pos)
             else
               (let ct1 = FStar_TypeChecker_Env.unfold_effect_abbrev env comp in
                match ct1.FStar_Syntax_Syntax.effect_args with
                | (wp, uu____13607)::uu____13608 ->
                    let uu____13635 =
                      let uu____13640 =
                        FStar_TypeChecker_Env.lookup_lid env
                          FStar_Parser_Const.as_requires in
                      FStar_All.pipe_left FStar_Pervasives_Native.fst
                        uu____13640 in
                    (match uu____13635 with
                     | (us_r, uu____13672) ->
                         let uu____13673 =
                           let uu____13678 =
                             FStar_TypeChecker_Env.lookup_lid env
                               FStar_Parser_Const.as_ensures in
                           FStar_All.pipe_left FStar_Pervasives_Native.fst
                             uu____13678 in
                         (match uu____13673 with
                          | (us_e, uu____13710) ->
                              let r =
                                (ct1.FStar_Syntax_Syntax.result_typ).FStar_Syntax_Syntax.pos in
                              let as_req =
                                let uu____13713 =
                                  let uu____13714 =
                                    FStar_Ident.set_lid_range
                                      FStar_Parser_Const.as_requires r in
                                  FStar_Syntax_Syntax.fvar uu____13714
                                    FStar_Syntax_Syntax.delta_equational
                                    FStar_Pervasives_Native.None in
                                FStar_Syntax_Syntax.mk_Tm_uinst uu____13713
                                  us_r in
                              let as_ens =
                                let uu____13716 =
                                  let uu____13717 =
                                    FStar_Ident.set_lid_range
                                      FStar_Parser_Const.as_ensures r in
                                  FStar_Syntax_Syntax.fvar uu____13717
                                    FStar_Syntax_Syntax.delta_equational
                                    FStar_Pervasives_Native.None in
                                FStar_Syntax_Syntax.mk_Tm_uinst uu____13716
                                  us_e in
                              let req =
                                let uu____13719 =
                                  let uu____13720 =
                                    let uu____13731 =
                                      FStar_Syntax_Syntax.as_arg wp in
                                    [uu____13731] in
                                  ((ct1.FStar_Syntax_Syntax.result_typ),
                                    (FStar_Pervasives_Native.Some
                                       FStar_Syntax_Syntax.imp_tag))
                                    :: uu____13720 in
                                FStar_Syntax_Syntax.mk_Tm_app as_req
                                  uu____13719
                                  (ct1.FStar_Syntax_Syntax.result_typ).FStar_Syntax_Syntax.pos in
                              let ens =
                                let uu____13769 =
                                  let uu____13770 =
                                    let uu____13781 =
                                      FStar_Syntax_Syntax.as_arg wp in
                                    [uu____13781] in
                                  ((ct1.FStar_Syntax_Syntax.result_typ),
                                    (FStar_Pervasives_Native.Some
                                       FStar_Syntax_Syntax.imp_tag))
                                    :: uu____13770 in
                                FStar_Syntax_Syntax.mk_Tm_app as_ens
                                  uu____13769
                                  (ct1.FStar_Syntax_Syntax.result_typ).FStar_Syntax_Syntax.pos in
                              let uu____13818 =
                                let uu____13821 = norm req in
                                FStar_Pervasives_Native.Some uu____13821 in
                              let uu____13822 =
                                let uu____13823 =
                                  mk_post_type
                                    ct1.FStar_Syntax_Syntax.result_typ ens in
                                norm uu____13823 in
                              (uu____13818, uu____13822)))
                | uu____13826 -> failwith "Impossible"))
let (reify_body :
  FStar_TypeChecker_Env.env ->
    FStar_TypeChecker_Env.steps ->
      FStar_Syntax_Syntax.term -> FStar_Syntax_Syntax.term)
  =
  fun env ->
    fun steps ->
      fun t ->
        let tm = FStar_Syntax_Util.mk_reify t in
        let tm' =
          FStar_TypeChecker_Normalize.normalize
            (FStar_List.append
               [FStar_TypeChecker_Env.Beta;
               FStar_TypeChecker_Env.Reify;
               FStar_TypeChecker_Env.Eager_unfolding;
               FStar_TypeChecker_Env.EraseUniverses;
               FStar_TypeChecker_Env.AllowUnboundUniverses;
               FStar_TypeChecker_Env.Exclude FStar_TypeChecker_Env.Zeta]
               steps) env tm in
        (let uu____13865 =
           FStar_All.pipe_left (FStar_TypeChecker_Env.debug env)
             (FStar_Options.Other "SMTEncodingReify") in
         if uu____13865
         then
           let uu____13870 = FStar_Syntax_Print.term_to_string tm in
           let uu____13872 = FStar_Syntax_Print.term_to_string tm' in
           FStar_Util.print2 "Reified body %s \nto %s\n" uu____13870
             uu____13872
         else ());
        tm'
let (reify_body_with_arg :
  FStar_TypeChecker_Env.env ->
    FStar_TypeChecker_Env.steps ->
      FStar_Syntax_Syntax.term ->
        FStar_Syntax_Syntax.arg -> FStar_Syntax_Syntax.term)
  =
  fun env ->
    fun steps ->
      fun head ->
        fun arg ->
          let tm =
            FStar_Syntax_Syntax.mk (FStar_Syntax_Syntax.Tm_app (head, [arg]))
              head.FStar_Syntax_Syntax.pos in
          let tm' =
            FStar_TypeChecker_Normalize.normalize
              (FStar_List.append
                 [FStar_TypeChecker_Env.Beta;
                 FStar_TypeChecker_Env.Reify;
                 FStar_TypeChecker_Env.Eager_unfolding;
                 FStar_TypeChecker_Env.EraseUniverses;
                 FStar_TypeChecker_Env.AllowUnboundUniverses;
                 FStar_TypeChecker_Env.Exclude FStar_TypeChecker_Env.Zeta]
                 steps) env tm in
          (let uu____13931 =
             FStar_All.pipe_left (FStar_TypeChecker_Env.debug env)
               (FStar_Options.Other "SMTEncodingReify") in
           if uu____13931
           then
             let uu____13936 = FStar_Syntax_Print.term_to_string tm in
             let uu____13938 = FStar_Syntax_Print.term_to_string tm' in
             FStar_Util.print2 "Reified body %s \nto %s\n" uu____13936
               uu____13938
           else ());
          tm'
let (remove_reify : FStar_Syntax_Syntax.term -> FStar_Syntax_Syntax.term) =
  fun t ->
    let uu____13949 =
      let uu____13951 =
        let uu____13952 = FStar_Syntax_Subst.compress t in
        uu____13952.FStar_Syntax_Syntax.n in
      match uu____13951 with
      | FStar_Syntax_Syntax.Tm_app uu____13956 -> false
      | uu____13974 -> true in
    if uu____13949
    then t
    else
      (let uu____13979 = FStar_Syntax_Util.head_and_args t in
       match uu____13979 with
       | (head, args) ->
           let uu____14022 =
             let uu____14024 =
               let uu____14025 = FStar_Syntax_Subst.compress head in
               uu____14025.FStar_Syntax_Syntax.n in
             match uu____14024 with
             | FStar_Syntax_Syntax.Tm_constant (FStar_Const.Const_reify) ->
                 true
             | uu____14030 -> false in
           if uu____14022
           then
             (match args with
              | x::[] -> FStar_Pervasives_Native.fst x
              | uu____14062 ->
                  failwith
                    "Impossible : Reify applied to multiple arguments after normalization.")
           else t)
let (maybe_instantiate :
  FStar_TypeChecker_Env.env ->
    FStar_Syntax_Syntax.term ->
      FStar_Syntax_Syntax.typ ->
        (FStar_Syntax_Syntax.term * FStar_Syntax_Syntax.typ *
          FStar_TypeChecker_Common.guard_t))
  =
  fun env ->
    fun e ->
      fun t ->
        let torig = FStar_Syntax_Subst.compress t in
        if Prims.op_Negation env.FStar_TypeChecker_Env.instantiate_imp
        then (e, torig, FStar_TypeChecker_Env.trivial_guard)
        else
          ((let uu____14109 =
              FStar_TypeChecker_Env.debug env FStar_Options.High in
            if uu____14109
            then
              let uu____14112 = FStar_Syntax_Print.term_to_string e in
              let uu____14114 = FStar_Syntax_Print.term_to_string t in
              let uu____14116 =
                let uu____14118 = FStar_TypeChecker_Env.expected_typ env in
                FStar_Common.string_of_option
                  FStar_Syntax_Print.term_to_string uu____14118 in
              FStar_Util.print3
                "maybe_instantiate: starting check for (%s) of type (%s), expected type is %s\n"
                uu____14112 uu____14114 uu____14116
            else ());
           (let unfolded_arrow_formals t1 =
              let rec aux bs t2 =
                let t3 = FStar_TypeChecker_Normalize.unfold_whnf env t2 in
                let uu____14154 = FStar_Syntax_Util.arrow_formals t3 in
                match uu____14154 with
                | (bs', t4) ->
                    (match bs' with
                     | [] -> bs
                     | bs'1 -> aux (FStar_List.append bs bs'1) t4) in
              aux [] t1 in
            let number_of_implicits t1 =
              let formals = unfolded_arrow_formals t1 in
              let n_implicits =
                let uu____14188 =
                  FStar_All.pipe_right formals
                    (FStar_Util.prefix_until
                       (fun uu____14266 ->
                          match uu____14266 with
                          | (uu____14274, imp) ->
                              (FStar_Option.isNone imp) ||
                                (let uu____14281 =
                                   FStar_Syntax_Util.eq_aqual imp
                                     (FStar_Pervasives_Native.Some
                                        FStar_Syntax_Syntax.Equality) in
                                 uu____14281 = FStar_Syntax_Util.Equal))) in
                match uu____14188 with
                | FStar_Pervasives_Native.None -> FStar_List.length formals
                | FStar_Pervasives_Native.Some
                    (implicits, _first_explicit, _rest) ->
                    FStar_List.length implicits in
              n_implicits in
            let inst_n_binders t1 =
              let uu____14400 = FStar_TypeChecker_Env.expected_typ env in
              match uu____14400 with
              | FStar_Pervasives_Native.None -> FStar_Pervasives_Native.None
              | FStar_Pervasives_Native.Some expected_t ->
                  let n_expected = number_of_implicits expected_t in
                  let n_available = number_of_implicits t1 in
                  if n_available < n_expected
                  then
                    let uu____14414 =
                      let uu____14420 =
                        let uu____14422 = FStar_Util.string_of_int n_expected in
                        let uu____14424 = FStar_Syntax_Print.term_to_string e in
                        let uu____14426 =
                          FStar_Util.string_of_int n_available in
                        FStar_Util.format3
                          "Expected a term with %s implicit arguments, but %s has only %s"
                          uu____14422 uu____14424 uu____14426 in
                      (FStar_Errors.Fatal_MissingImplicitArguments,
                        uu____14420) in
                    let uu____14430 = FStar_TypeChecker_Env.get_range env in
                    FStar_Errors.raise_error uu____14414 uu____14430
                  else
                    FStar_Pervasives_Native.Some (n_available - n_expected) in
            let decr_inst uu___7_14448 =
              match uu___7_14448 with
              | FStar_Pervasives_Native.None -> FStar_Pervasives_Native.None
              | FStar_Pervasives_Native.Some i ->
                  FStar_Pervasives_Native.Some (i - Prims.int_one) in
            let t1 = FStar_TypeChecker_Normalize.unfold_whnf env t in
            match t1.FStar_Syntax_Syntax.n with
            | FStar_Syntax_Syntax.Tm_arrow (bs, c) ->
                let uu____14491 = FStar_Syntax_Subst.open_comp bs c in
                (match uu____14491 with
                 | (bs1, c1) ->
                     let rec aux subst inst_n bs2 =
                       match (inst_n, bs2) with
                       | (FStar_Pervasives_Native.Some uu____14622,
                          uu____14609) when uu____14622 = Prims.int_zero ->
                           ([], bs2, subst,
                             FStar_TypeChecker_Env.trivial_guard)
                       | (uu____14655,
                          (x, FStar_Pervasives_Native.Some
                           (FStar_Syntax_Syntax.Implicit uu____14657))::rest)
                           ->
                           let t2 =
                             FStar_Syntax_Subst.subst subst
                               x.FStar_Syntax_Syntax.sort in
                           let uu____14691 =
                             new_implicit_var
                               "Instantiation of implicit argument"
                               e.FStar_Syntax_Syntax.pos env t2 in
                           (match uu____14691 with
                            | (v, uu____14732, g) ->
                                ((let uu____14747 =
                                    FStar_TypeChecker_Env.debug env
                                      FStar_Options.High in
                                  if uu____14747
                                  then
                                    let uu____14750 =
                                      FStar_Syntax_Print.term_to_string v in
                                    FStar_Util.print1
                                      "maybe_instantiate: Instantiating implicit with %s\n"
                                      uu____14750
                                  else ());
                                 (let subst1 =
                                    (FStar_Syntax_Syntax.NT (x, v)) :: subst in
                                  let uu____14760 =
                                    aux subst1 (decr_inst inst_n) rest in
                                  match uu____14760 with
                                  | (args, bs3, subst2, g') ->
                                      let uu____14853 =
                                        FStar_TypeChecker_Env.conj_guard g g' in
                                      (((v,
                                          (FStar_Pervasives_Native.Some
                                             FStar_Syntax_Syntax.imp_tag)) ::
                                        args), bs3, subst2, uu____14853))))
                       | (uu____14880,
                          (x, FStar_Pervasives_Native.Some
                           (FStar_Syntax_Syntax.Meta tac_or_attr))::rest) ->
                           let t2 =
                             FStar_Syntax_Subst.subst subst
                               x.FStar_Syntax_Syntax.sort in
                           let meta_t =
                             match tac_or_attr with
                             | FStar_Syntax_Syntax.Arg_qualifier_meta_tac tau
                                 ->
                                 let uu____14919 =
                                   let uu____14926 = FStar_Dyn.mkdyn env in
                                   (uu____14926, tau) in
                                 FStar_Syntax_Syntax.Ctx_uvar_meta_tac
                                   uu____14919
                             | FStar_Syntax_Syntax.Arg_qualifier_meta_attr
                                 attr ->
                                 FStar_Syntax_Syntax.Ctx_uvar_meta_attr attr in
                           let uu____14932 =
                             FStar_TypeChecker_Env.new_implicit_var_aux
                               "Instantiation of meta argument"
                               e.FStar_Syntax_Syntax.pos env t2
                               FStar_Syntax_Syntax.Strict
                               (FStar_Pervasives_Native.Some meta_t) in
                           (match uu____14932 with
                            | (v, uu____14973, g) ->
                                ((let uu____14988 =
                                    FStar_TypeChecker_Env.debug env
                                      FStar_Options.High in
                                  if uu____14988
                                  then
                                    let uu____14991 =
                                      FStar_Syntax_Print.term_to_string v in
                                    FStar_Util.print1
                                      "maybe_instantiate: Instantiating meta argument with %s\n"
                                      uu____14991
                                  else ());
                                 (let subst1 =
                                    (FStar_Syntax_Syntax.NT (x, v)) :: subst in
                                  let uu____15001 =
                                    aux subst1 (decr_inst inst_n) rest in
                                  match uu____15001 with
                                  | (args, bs3, subst2, g') ->
                                      let uu____15094 =
                                        FStar_TypeChecker_Env.conj_guard g g' in
                                      (((v,
                                          (FStar_Pervasives_Native.Some
                                             FStar_Syntax_Syntax.imp_tag)) ::
                                        args), bs3, subst2, uu____15094))))
                       | (uu____15121, bs3) ->
                           ([], bs3, subst,
                             FStar_TypeChecker_Env.trivial_guard) in
                     let uu____15169 =
                       let uu____15196 = inst_n_binders t1 in
                       aux [] uu____15196 bs1 in
                     (match uu____15169 with
                      | (args, bs2, subst, guard) ->
                          (match (args, bs2) with
                           | ([], uu____15268) -> (e, torig, guard)
                           | (uu____15299, []) when
                               let uu____15330 =
                                 FStar_Syntax_Util.is_total_comp c1 in
                               Prims.op_Negation uu____15330 ->
                               (e, torig,
                                 FStar_TypeChecker_Env.trivial_guard)
                           | uu____15332 ->
                               let t2 =
                                 match bs2 with
                                 | [] -> FStar_Syntax_Util.comp_result c1
                                 | uu____15360 ->
                                     FStar_Syntax_Util.arrow bs2 c1 in
                               let t3 = FStar_Syntax_Subst.subst subst t2 in
                               let e1 =
                                 FStar_Syntax_Syntax.mk_Tm_app e args
                                   e.FStar_Syntax_Syntax.pos in
                               (e1, t3, guard))))
            | uu____15371 -> (e, torig, FStar_TypeChecker_Env.trivial_guard)))
let (string_of_univs :
  FStar_Syntax_Syntax.universe_uvar FStar_Util.set -> Prims.string) =
  fun univs ->
    let uu____15383 =
      let uu____15387 = FStar_Util.set_elements univs in
      FStar_All.pipe_right uu____15387
        (FStar_List.map
           (fun u ->
              let uu____15399 = FStar_Syntax_Unionfind.univ_uvar_id u in
              FStar_All.pipe_right uu____15399 FStar_Util.string_of_int)) in
    FStar_All.pipe_right uu____15383 (FStar_String.concat ", ")
let (gen_univs :
  FStar_TypeChecker_Env.env ->
    FStar_Syntax_Syntax.universe_uvar FStar_Util.set ->
      FStar_Syntax_Syntax.univ_name Prims.list)
  =
  fun env ->
    fun x ->
      let uu____15427 = FStar_Util.set_is_empty x in
      if uu____15427
      then []
      else
        (let s =
           let uu____15447 =
             let uu____15450 = FStar_TypeChecker_Env.univ_vars env in
             FStar_Util.set_difference x uu____15450 in
           FStar_All.pipe_right uu____15447 FStar_Util.set_elements in
         (let uu____15468 =
            FStar_All.pipe_left (FStar_TypeChecker_Env.debug env)
              (FStar_Options.Other "Gen") in
          if uu____15468
          then
            let uu____15473 =
              let uu____15475 = FStar_TypeChecker_Env.univ_vars env in
              string_of_univs uu____15475 in
            FStar_Util.print1 "univ_vars in env: %s\n" uu____15473
          else ());
         (let r =
            let uu____15484 = FStar_TypeChecker_Env.get_range env in
            FStar_Pervasives_Native.Some uu____15484 in
          let u_names =
            FStar_All.pipe_right s
              (FStar_List.map
                 (fun u ->
                    let u_name = FStar_Syntax_Syntax.new_univ_name r in
                    (let uu____15529 =
                       FStar_All.pipe_left (FStar_TypeChecker_Env.debug env)
                         (FStar_Options.Other "Gen") in
                     if uu____15529
                     then
                       let uu____15534 =
                         let uu____15536 =
                           FStar_Syntax_Unionfind.univ_uvar_id u in
                         FStar_All.pipe_left FStar_Util.string_of_int
                           uu____15536 in
                       let uu____15540 =
                         FStar_Syntax_Print.univ_to_string
                           (FStar_Syntax_Syntax.U_unif u) in
                       let uu____15542 =
                         FStar_Syntax_Print.univ_to_string
                           (FStar_Syntax_Syntax.U_name u_name) in
                       FStar_Util.print3 "Setting ?%s (%s) to %s\n"
                         uu____15534 uu____15540 uu____15542
                     else ());
                    FStar_Syntax_Unionfind.univ_change u
                      (FStar_Syntax_Syntax.U_name u_name);
                    u_name)) in
          u_names))
let (gather_free_univnames :
  FStar_TypeChecker_Env.env ->
    FStar_Syntax_Syntax.term -> FStar_Syntax_Syntax.univ_name Prims.list)
  =
  fun env ->
    fun t ->
      let ctx_univnames = FStar_TypeChecker_Env.univnames env in
      let tm_univnames = FStar_Syntax_Free.univnames t in
      let univnames =
        let uu____15572 =
          FStar_Util.set_difference tm_univnames ctx_univnames in
        FStar_All.pipe_right uu____15572 FStar_Util.set_elements in
      univnames
let (check_universe_generalization :
  FStar_Syntax_Syntax.univ_name Prims.list ->
    FStar_Syntax_Syntax.univ_name Prims.list ->
      FStar_Syntax_Syntax.term -> FStar_Syntax_Syntax.univ_name Prims.list)
  =
  fun explicit_univ_names ->
    fun generalized_univ_names ->
      fun t ->
        match (explicit_univ_names, generalized_univ_names) with
        | ([], uu____15611) -> generalized_univ_names
        | (uu____15618, []) -> explicit_univ_names
        | uu____15625 ->
            let uu____15634 =
              let uu____15640 =
                let uu____15642 = FStar_Syntax_Print.term_to_string t in
                Prims.op_Hat
                  "Generalized universe in a term containing explicit universe annotation : "
                  uu____15642 in
              (FStar_Errors.Fatal_UnexpectedGeneralizedUniverse, uu____15640) in
            FStar_Errors.raise_error uu____15634 t.FStar_Syntax_Syntax.pos
let (generalize_universes :
  FStar_TypeChecker_Env.env ->
    FStar_Syntax_Syntax.term -> FStar_Syntax_Syntax.tscheme)
  =
  fun env ->
    fun t0 ->
      let t =
        FStar_TypeChecker_Normalize.normalize
          [FStar_TypeChecker_Env.NoFullNorm;
          FStar_TypeChecker_Env.Beta;
          FStar_TypeChecker_Env.DoNotUnfoldPureLets] env t0 in
      let univnames = gather_free_univnames env t in
      (let uu____15664 =
         FStar_All.pipe_left (FStar_TypeChecker_Env.debug env)
           (FStar_Options.Other "Gen") in
       if uu____15664
       then
         let uu____15669 = FStar_Syntax_Print.term_to_string t in
         let uu____15671 = FStar_Syntax_Print.univ_names_to_string univnames in
         FStar_Util.print2
           "generalizing universes in the term (post norm): %s with univnames: %s\n"
           uu____15669 uu____15671
       else ());
      (let univs = FStar_Syntax_Free.univs t in
       (let uu____15680 =
          FStar_All.pipe_left (FStar_TypeChecker_Env.debug env)
            (FStar_Options.Other "Gen") in
        if uu____15680
        then
          let uu____15685 = string_of_univs univs in
          FStar_Util.print1 "univs to gen : %s\n" uu____15685
        else ());
       (let gen = gen_univs env univs in
        (let uu____15694 =
           FStar_All.pipe_left (FStar_TypeChecker_Env.debug env)
             (FStar_Options.Other "Gen") in
         if uu____15694
         then
           let uu____15699 = FStar_Syntax_Print.term_to_string t in
           let uu____15701 = FStar_Syntax_Print.univ_names_to_string gen in
           FStar_Util.print2 "After generalization, t: %s and univs: %s\n"
             uu____15699 uu____15701
         else ());
        (let univs1 = check_universe_generalization univnames gen t0 in
         let t1 = FStar_TypeChecker_Normalize.reduce_uvar_solutions env t in
         let ts = FStar_Syntax_Subst.close_univ_vars univs1 t1 in
         (univs1, ts))))
let (gen :
  FStar_TypeChecker_Env.env ->
    Prims.bool ->
      (FStar_Syntax_Syntax.lbname * FStar_Syntax_Syntax.term *
        FStar_Syntax_Syntax.comp) Prims.list ->
        (FStar_Syntax_Syntax.lbname * FStar_Syntax_Syntax.univ_name
          Prims.list * FStar_Syntax_Syntax.term * FStar_Syntax_Syntax.comp *
          FStar_Syntax_Syntax.binder Prims.list) Prims.list
          FStar_Pervasives_Native.option)
  =
  fun env ->
    fun is_rec ->
      fun lecs ->
        let uu____15785 =
          let uu____15787 =
            FStar_Util.for_all
              (fun uu____15801 ->
                 match uu____15801 with
                 | (uu____15811, uu____15812, c) ->
                     FStar_Syntax_Util.is_pure_or_ghost_comp c) lecs in
          FStar_All.pipe_left Prims.op_Negation uu____15787 in
        if uu____15785
        then FStar_Pervasives_Native.None
        else
          (let norm c =
             (let uu____15864 =
                FStar_TypeChecker_Env.debug env FStar_Options.Medium in
              if uu____15864
              then
                let uu____15867 = FStar_Syntax_Print.comp_to_string c in
                FStar_Util.print1 "Normalizing before generalizing:\n\t %s\n"
                  uu____15867
              else ());
             (let c1 =
                FStar_TypeChecker_Normalize.normalize_comp
                  [FStar_TypeChecker_Env.Beta;
                  FStar_TypeChecker_Env.Exclude FStar_TypeChecker_Env.Zeta;
                  FStar_TypeChecker_Env.NoFullNorm;
                  FStar_TypeChecker_Env.DoNotUnfoldPureLets] env c in
              (let uu____15874 =
                 FStar_TypeChecker_Env.debug env FStar_Options.Medium in
               if uu____15874
               then
                 let uu____15877 = FStar_Syntax_Print.comp_to_string c1 in
                 FStar_Util.print1 "Normalized to:\n\t %s\n" uu____15877
               else ());
              c1) in
           let env_uvars = FStar_TypeChecker_Env.uvars_in_env env in
           let gen_uvars uvs =
             let uu____15895 = FStar_Util.set_difference uvs env_uvars in
             FStar_All.pipe_right uu____15895 FStar_Util.set_elements in
           let univs_and_uvars_of_lec uu____15929 =
             match uu____15929 with
             | (lbname, e, c) ->
                 let c1 = norm c in
                 let t = FStar_Syntax_Util.comp_result c1 in
                 let univs = FStar_Syntax_Free.univs t in
                 let uvt = FStar_Syntax_Free.uvars t in
                 ((let uu____15966 =
                     FStar_All.pipe_left (FStar_TypeChecker_Env.debug env)
                       (FStar_Options.Other "Gen") in
                   if uu____15966
                   then
                     let uu____15971 =
                       let uu____15973 =
                         let uu____15977 = FStar_Util.set_elements univs in
                         FStar_All.pipe_right uu____15977
                           (FStar_List.map
                              (fun u ->
                                 FStar_Syntax_Print.univ_to_string
                                   (FStar_Syntax_Syntax.U_unif u))) in
                       FStar_All.pipe_right uu____15973
                         (FStar_String.concat ", ") in
                     let uu____16033 =
                       let uu____16035 =
                         let uu____16039 = FStar_Util.set_elements uvt in
                         FStar_All.pipe_right uu____16039
                           (FStar_List.map
                              (fun u ->
                                 let uu____16052 =
                                   FStar_Syntax_Print.uvar_to_string
                                     u.FStar_Syntax_Syntax.ctx_uvar_head in
                                 let uu____16054 =
                                   FStar_Syntax_Print.term_to_string
                                     u.FStar_Syntax_Syntax.ctx_uvar_typ in
                                 FStar_Util.format2 "(%s : %s)" uu____16052
                                   uu____16054)) in
                       FStar_All.pipe_right uu____16035
                         (FStar_String.concat ", ") in
                     FStar_Util.print2
                       "^^^^\n\tFree univs = %s\n\tFree uvt=%s\n" uu____15971
                       uu____16033
                   else ());
                  (let univs1 =
                     let uu____16068 = FStar_Util.set_elements uvt in
                     FStar_List.fold_left
                       (fun univs1 ->
                          fun uv ->
                            let uu____16080 =
                              FStar_Syntax_Free.univs
                                uv.FStar_Syntax_Syntax.ctx_uvar_typ in
                            FStar_Util.set_union univs1 uu____16080) univs
                       uu____16068 in
                   let uvs = gen_uvars uvt in
                   (let uu____16087 =
                      FStar_All.pipe_left (FStar_TypeChecker_Env.debug env)
                        (FStar_Options.Other "Gen") in
                    if uu____16087
                    then
                      let uu____16092 =
                        let uu____16094 =
                          let uu____16098 = FStar_Util.set_elements univs1 in
                          FStar_All.pipe_right uu____16098
                            (FStar_List.map
                               (fun u ->
                                  FStar_Syntax_Print.univ_to_string
                                    (FStar_Syntax_Syntax.U_unif u))) in
                        FStar_All.pipe_right uu____16094
                          (FStar_String.concat ", ") in
                      let uu____16154 =
                        let uu____16156 =
                          FStar_All.pipe_right uvs
                            (FStar_List.map
                               (fun u ->
                                  let uu____16170 =
                                    FStar_Syntax_Print.uvar_to_string
                                      u.FStar_Syntax_Syntax.ctx_uvar_head in
                                  let uu____16172 =
                                    FStar_TypeChecker_Normalize.term_to_string
                                      env u.FStar_Syntax_Syntax.ctx_uvar_typ in
                                  FStar_Util.format2 "(%s : %s)" uu____16170
                                    uu____16172)) in
                        FStar_All.pipe_right uu____16156
                          (FStar_String.concat ", ") in
                      FStar_Util.print2
                        "^^^^\n\tFree univs = %s\n\tgen_uvars =%s"
                        uu____16092 uu____16154
                    else ());
                   (univs1, uvs, (lbname, e, c1)))) in
           let uu____16193 =
             let uu____16210 = FStar_List.hd lecs in
             univs_and_uvars_of_lec uu____16210 in
           match uu____16193 with
           | (univs, uvs, lec_hd) ->
               let force_univs_eq lec2 u1 u2 =
                 let uu____16300 =
                   (FStar_Util.set_is_subset_of u1 u2) &&
                     (FStar_Util.set_is_subset_of u2 u1) in
                 if uu____16300
                 then ()
                 else
                   (let uu____16305 = lec_hd in
                    match uu____16305 with
                    | (lb1, uu____16313, uu____16314) ->
                        let uu____16315 = lec2 in
                        (match uu____16315 with
                         | (lb2, uu____16323, uu____16324) ->
                             let msg =
                               let uu____16327 =
                                 FStar_Syntax_Print.lbname_to_string lb1 in
                               let uu____16329 =
                                 FStar_Syntax_Print.lbname_to_string lb2 in
                               FStar_Util.format2
                                 "Generalizing the types of these mutually recursive definitions requires an incompatible set of universes for %s and %s"
                                 uu____16327 uu____16329 in
                             let uu____16332 =
                               FStar_TypeChecker_Env.get_range env in
                             FStar_Errors.raise_error
                               (FStar_Errors.Fatal_IncompatibleSetOfUniverse,
                                 msg) uu____16332)) in
               let force_uvars_eq lec2 u1 u2 =
                 let uvars_subseteq u11 u21 =
                   FStar_All.pipe_right u11
                     (FStar_Util.for_all
                        (fun u ->
                           FStar_All.pipe_right u21
                             (FStar_Util.for_some
                                (fun u' ->
                                   FStar_Syntax_Unionfind.equiv
                                     u.FStar_Syntax_Syntax.ctx_uvar_head
                                     u'.FStar_Syntax_Syntax.ctx_uvar_head)))) in
                 let uu____16400 =
                   (uvars_subseteq u1 u2) && (uvars_subseteq u2 u1) in
                 if uu____16400
                 then ()
                 else
                   (let uu____16405 = lec_hd in
                    match uu____16405 with
                    | (lb1, uu____16413, uu____16414) ->
                        let uu____16415 = lec2 in
                        (match uu____16415 with
                         | (lb2, uu____16423, uu____16424) ->
                             let msg =
                               let uu____16427 =
                                 FStar_Syntax_Print.lbname_to_string lb1 in
                               let uu____16429 =
                                 FStar_Syntax_Print.lbname_to_string lb2 in
                               FStar_Util.format2
                                 "Generalizing the types of these mutually recursive definitions requires an incompatible number of types for %s and %s"
                                 uu____16427 uu____16429 in
                             let uu____16432 =
                               FStar_TypeChecker_Env.get_range env in
                             FStar_Errors.raise_error
                               (FStar_Errors.Fatal_IncompatibleNumberOfTypes,
                                 msg) uu____16432)) in
               let lecs1 =
                 let uu____16443 = FStar_List.tl lecs in
                 FStar_List.fold_right
                   (fun this_lec ->
                      fun lecs1 ->
                        let uu____16496 = univs_and_uvars_of_lec this_lec in
                        match uu____16496 with
                        | (this_univs, this_uvs, this_lec1) ->
                            (force_univs_eq this_lec1 univs this_univs;
                             force_uvars_eq this_lec1 uvs this_uvs;
                             this_lec1
                             ::
                             lecs1)) uu____16443 [] in
               let lecs2 = lec_hd :: lecs1 in
               let gen_types uvs1 =
                 let fail rng k =
                   let uu____16606 = lec_hd in
                   match uu____16606 with
                   | (lbname, e, c) ->
                       let uu____16616 =
                         let uu____16622 =
                           let uu____16624 =
                             FStar_Syntax_Print.term_to_string k in
                           let uu____16626 =
                             FStar_Syntax_Print.lbname_to_string lbname in
                           let uu____16628 =
                             FStar_Syntax_Print.term_to_string
                               (FStar_Syntax_Util.comp_result c) in
                           FStar_Util.format3
                             "Failed to resolve implicit argument of type '%s' in the type of %s (%s)"
                             uu____16624 uu____16626 uu____16628 in
                         (FStar_Errors.Fatal_FailToResolveImplicitArgument,
                           uu____16622) in
                       FStar_Errors.raise_error uu____16616 rng in
                 FStar_All.pipe_right uvs1
                   (FStar_List.map
                      (fun u ->
                         let uu____16650 =
                           FStar_Syntax_Unionfind.find
                             u.FStar_Syntax_Syntax.ctx_uvar_head in
                         match uu____16650 with
                         | FStar_Pervasives_Native.Some uu____16659 ->
                             failwith
                               "Unexpected instantiation of mutually recursive uvar"
                         | uu____16667 ->
                             let k =
                               FStar_TypeChecker_Normalize.normalize
                                 [FStar_TypeChecker_Env.Beta;
                                 FStar_TypeChecker_Env.Exclude
                                   FStar_TypeChecker_Env.Zeta] env
                                 u.FStar_Syntax_Syntax.ctx_uvar_typ in
                             let uu____16671 =
                               FStar_Syntax_Util.arrow_formals k in
                             (match uu____16671 with
                              | (bs, kres) ->
                                  ((let uu____16691 =
                                      let uu____16692 =
                                        let uu____16695 =
                                          FStar_TypeChecker_Normalize.unfold_whnf
                                            env kres in
                                        FStar_Syntax_Util.unrefine
                                          uu____16695 in
                                      uu____16692.FStar_Syntax_Syntax.n in
                                    match uu____16691 with
                                    | FStar_Syntax_Syntax.Tm_type uu____16696
                                        ->
                                        let free =
                                          FStar_Syntax_Free.names kres in
                                        let uu____16700 =
                                          let uu____16702 =
                                            FStar_Util.set_is_empty free in
                                          Prims.op_Negation uu____16702 in
                                        if uu____16700
                                        then
                                          fail
                                            u.FStar_Syntax_Syntax.ctx_uvar_range
                                            kres
                                        else ()
                                    | uu____16707 ->
                                        fail
                                          u.FStar_Syntax_Syntax.ctx_uvar_range
                                          kres);
                                   (let a =
                                      let uu____16709 =
                                        let uu____16712 =
                                          FStar_TypeChecker_Env.get_range env in
                                        FStar_All.pipe_left
                                          (fun uu____16715 ->
                                             FStar_Pervasives_Native.Some
                                               uu____16715) uu____16712 in
                                      FStar_Syntax_Syntax.new_bv uu____16709
                                        kres in
                                    let t =
                                      match bs with
                                      | [] ->
                                          FStar_Syntax_Syntax.bv_to_name a
                                      | uu____16723 ->
                                          let uu____16724 =
                                            FStar_Syntax_Syntax.bv_to_name a in
                                          FStar_Syntax_Util.abs bs
                                            uu____16724
                                            (FStar_Pervasives_Native.Some
                                               (FStar_Syntax_Util.residual_tot
                                                  kres)) in
                                    FStar_Syntax_Util.set_uvar
                                      u.FStar_Syntax_Syntax.ctx_uvar_head t;
                                    (a,
                                      (FStar_Pervasives_Native.Some
                                         FStar_Syntax_Syntax.imp_tag))))))) in
               let gen_univs1 = gen_univs env univs in
               let gen_tvars = gen_types uvs in
               let ecs =
                 FStar_All.pipe_right lecs2
                   (FStar_List.map
                      (fun uu____16827 ->
                         match uu____16827 with
                         | (lbname, e, c) ->
                             let uu____16873 =
                               match (gen_tvars, gen_univs1) with
                               | ([], []) -> (e, c, [])
                               | uu____16934 ->
                                   let uu____16947 = (e, c) in
                                   (match uu____16947 with
                                    | (e0, c0) ->
                                        let c1 =
                                          FStar_TypeChecker_Normalize.normalize_comp
                                            [FStar_TypeChecker_Env.Beta;
                                            FStar_TypeChecker_Env.DoNotUnfoldPureLets;
                                            FStar_TypeChecker_Env.CompressUvars;
                                            FStar_TypeChecker_Env.NoFullNorm;
                                            FStar_TypeChecker_Env.Exclude
                                              FStar_TypeChecker_Env.Zeta] env
                                            c in
                                        let e1 =
                                          FStar_TypeChecker_Normalize.reduce_uvar_solutions
                                            env e in
                                        let e2 =
                                          if is_rec
                                          then
                                            let tvar_args =
                                              FStar_List.map
                                                (fun uu____16987 ->
                                                   match uu____16987 with
                                                   | (x, uu____16993) ->
                                                       let uu____16994 =
                                                         FStar_Syntax_Syntax.bv_to_name
                                                           x in
                                                       FStar_Syntax_Syntax.iarg
                                                         uu____16994)
                                                gen_tvars in
                                            let instantiate_lbname_with_app
                                              tm fv =
                                              let uu____17012 =
                                                let uu____17014 =
                                                  FStar_Util.right lbname in
                                                FStar_Syntax_Syntax.fv_eq fv
                                                  uu____17014 in
                                              if uu____17012
                                              then
                                                FStar_Syntax_Syntax.mk_Tm_app
                                                  tm tvar_args
                                                  tm.FStar_Syntax_Syntax.pos
                                              else tm in
                                            FStar_Syntax_InstFV.inst
                                              instantiate_lbname_with_app e1
                                          else e1 in
                                        let t =
                                          let uu____17023 =
                                            let uu____17024 =
                                              FStar_Syntax_Subst.compress
                                                (FStar_Syntax_Util.comp_result
                                                   c1) in
                                            uu____17024.FStar_Syntax_Syntax.n in
                                          match uu____17023 with
                                          | FStar_Syntax_Syntax.Tm_arrow
                                              (bs, cod) ->
                                              let uu____17049 =
                                                FStar_Syntax_Subst.open_comp
                                                  bs cod in
                                              (match uu____17049 with
                                               | (bs1, cod1) ->
                                                   FStar_Syntax_Util.arrow
                                                     (FStar_List.append
                                                        gen_tvars bs1) cod1)
                                          | uu____17060 ->
                                              FStar_Syntax_Util.arrow
                                                gen_tvars c1 in
                                        let e' =
                                          FStar_Syntax_Util.abs gen_tvars e2
                                            (FStar_Pervasives_Native.Some
                                               (FStar_Syntax_Util.residual_comp_of_comp
                                                  c1)) in
                                        let uu____17064 =
                                          FStar_Syntax_Syntax.mk_Total t in
                                        (e', uu____17064, gen_tvars)) in
                             (match uu____16873 with
                              | (e1, c1, gvs) ->
                                  (lbname, gen_univs1, e1, c1, gvs)))) in
               FStar_Pervasives_Native.Some ecs)
let (generalize' :
  FStar_TypeChecker_Env.env ->
    Prims.bool ->
      (FStar_Syntax_Syntax.lbname * FStar_Syntax_Syntax.term *
        FStar_Syntax_Syntax.comp) Prims.list ->
        (FStar_Syntax_Syntax.lbname * FStar_Syntax_Syntax.univ_names *
          FStar_Syntax_Syntax.term * FStar_Syntax_Syntax.comp *
          FStar_Syntax_Syntax.binder Prims.list) Prims.list)
  =
  fun env ->
    fun is_rec ->
      fun lecs ->
        (let uu____17211 = FStar_TypeChecker_Env.debug env FStar_Options.Low in
         if uu____17211
         then
           let uu____17214 =
             let uu____17216 =
               FStar_List.map
                 (fun uu____17231 ->
                    match uu____17231 with
                    | (lb, uu____17240, uu____17241) ->
                        FStar_Syntax_Print.lbname_to_string lb) lecs in
             FStar_All.pipe_right uu____17216 (FStar_String.concat ", ") in
           FStar_Util.print1 "Generalizing: %s\n" uu____17214
         else ());
        (let univnames_lecs =
           FStar_List.map
             (fun uu____17267 ->
                match uu____17267 with
                | (l, t, c) -> gather_free_univnames env t) lecs in
         let generalized_lecs =
           let uu____17296 = gen env is_rec lecs in
           match uu____17296 with
           | FStar_Pervasives_Native.None ->
               FStar_All.pipe_right lecs
                 (FStar_List.map
                    (fun uu____17395 ->
                       match uu____17395 with
                       | (l, t, c) -> (l, [], t, c, [])))
           | FStar_Pervasives_Native.Some luecs ->
               ((let uu____17457 =
                   FStar_TypeChecker_Env.debug env FStar_Options.Medium in
                 if uu____17457
                 then
                   FStar_All.pipe_right luecs
                     (FStar_List.iter
                        (fun uu____17505 ->
                           match uu____17505 with
                           | (l, us, e, c, gvs) ->
                               let uu____17539 =
                                 FStar_Range.string_of_range
                                   e.FStar_Syntax_Syntax.pos in
                               let uu____17541 =
                                 FStar_Syntax_Print.lbname_to_string l in
                               let uu____17543 =
                                 FStar_Syntax_Print.term_to_string
                                   (FStar_Syntax_Util.comp_result c) in
                               let uu____17545 =
                                 FStar_Syntax_Print.term_to_string e in
                               let uu____17547 =
                                 FStar_Syntax_Print.binders_to_string ", "
                                   gvs in
                               FStar_Util.print5
                                 "(%s) Generalized %s at type %s\n%s\nVars = (%s)\n"
                                 uu____17539 uu____17541 uu____17543
                                 uu____17545 uu____17547))
                 else ());
                luecs) in
         FStar_List.map2
           (fun univnames ->
              fun uu____17592 ->
                match uu____17592 with
                | (l, generalized_univs, t, c, gvs) ->
                    let uu____17636 =
                      check_universe_generalization univnames
                        generalized_univs t in
                    (l, uu____17636, t, c, gvs)) univnames_lecs
           generalized_lecs)
let (generalize :
  FStar_TypeChecker_Env.env ->
    Prims.bool ->
      (FStar_Syntax_Syntax.lbname * FStar_Syntax_Syntax.term *
        FStar_Syntax_Syntax.comp) Prims.list ->
        (FStar_Syntax_Syntax.lbname * FStar_Syntax_Syntax.univ_names *
          FStar_Syntax_Syntax.term * FStar_Syntax_Syntax.comp *
          FStar_Syntax_Syntax.binder Prims.list) Prims.list)
  =
  fun env ->
    fun is_rec ->
      fun lecs ->
        let uu____17691 =
          let uu____17695 =
            let uu____17697 = FStar_TypeChecker_Env.current_module env in
            FStar_Ident.string_of_lid uu____17697 in
          FStar_Pervasives_Native.Some uu____17695 in
        FStar_Profiling.profile
          (fun uu____17714 -> generalize' env is_rec lecs) uu____17691
          "FStar.TypeChecker.Util.generalize"
let (check_has_type :
  FStar_TypeChecker_Env.env ->
    FStar_Syntax_Syntax.term ->
      FStar_TypeChecker_Common.lcomp ->
        FStar_Syntax_Syntax.typ ->
          (FStar_Syntax_Syntax.term * FStar_TypeChecker_Common.lcomp *
            FStar_TypeChecker_Common.guard_t))
  =
  fun env ->
    fun e ->
      fun lc ->
        fun t2 ->
          let env1 =
            FStar_TypeChecker_Env.set_range env e.FStar_Syntax_Syntax.pos in
          let check env2 t1 t21 =
            if env2.FStar_TypeChecker_Env.use_eq_strict
            then
              let uu____17771 =
                FStar_TypeChecker_Rel.get_teq_predicate env2 t1 t21 in
              match uu____17771 with
              | FStar_Pervasives_Native.None -> FStar_Pervasives_Native.None
              | FStar_Pervasives_Native.Some f ->
                  let uu____17777 = FStar_TypeChecker_Env.apply_guard f e in
                  FStar_All.pipe_right uu____17777
                    (fun uu____17780 ->
                       FStar_Pervasives_Native.Some uu____17780)
            else
              if env2.FStar_TypeChecker_Env.use_eq
              then FStar_TypeChecker_Rel.try_teq true env2 t1 t21
              else
                (let uu____17789 =
                   FStar_TypeChecker_Rel.get_subtyping_predicate env2 t1 t21 in
                 match uu____17789 with
                 | FStar_Pervasives_Native.None ->
                     FStar_Pervasives_Native.None
                 | FStar_Pervasives_Native.Some f ->
                     let uu____17795 = FStar_TypeChecker_Env.apply_guard f e in
                     FStar_All.pipe_left
                       (fun uu____17798 ->
                          FStar_Pervasives_Native.Some uu____17798)
                       uu____17795) in
          let uu____17799 = maybe_coerce_lc env1 e lc t2 in
          match uu____17799 with
          | (e1, lc1, g_c) ->
              let uu____17815 =
                check env1 lc1.FStar_TypeChecker_Common.res_typ t2 in
              (match uu____17815 with
               | FStar_Pervasives_Native.None ->
                   let uu____17824 =
                     FStar_TypeChecker_Err.expected_expression_of_type env1
                       t2 e1 lc1.FStar_TypeChecker_Common.res_typ in
                   let uu____17830 = FStar_TypeChecker_Env.get_range env1 in
                   FStar_Errors.raise_error uu____17824 uu____17830
               | FStar_Pervasives_Native.Some g ->
                   ((let uu____17839 =
                       FStar_All.pipe_left (FStar_TypeChecker_Env.debug env1)
                         (FStar_Options.Other "Rel") in
                     if uu____17839
                     then
                       let uu____17844 =
                         FStar_TypeChecker_Rel.guard_to_string env1 g in
                       FStar_All.pipe_left
                         (FStar_Util.print1 "Applied guard is %s\n")
                         uu____17844
                     else ());
                    (let uu____17850 = FStar_TypeChecker_Env.conj_guard g g_c in
                     (e1, lc1, uu____17850))))
let (check_top_level :
  FStar_TypeChecker_Env.env ->
    FStar_TypeChecker_Common.guard_t ->
      FStar_TypeChecker_Common.lcomp ->
        (Prims.bool * FStar_Syntax_Syntax.comp))
  =
  fun env ->
    fun g ->
      fun lc ->
        (let uu____17878 =
           FStar_TypeChecker_Env.debug env FStar_Options.Medium in
         if uu____17878
         then
           let uu____17881 = FStar_TypeChecker_Common.lcomp_to_string lc in
           FStar_Util.print1 "check_top_level, lc = %s\n" uu____17881
         else ());
        (let discharge g1 =
           FStar_TypeChecker_Rel.force_trivial_guard env g1;
           FStar_TypeChecker_Common.is_pure_lcomp lc in
         let g1 = FStar_TypeChecker_Rel.solve_deferred_constraints env g in
         let uu____17895 = FStar_TypeChecker_Common.lcomp_comp lc in
         match uu____17895 with
         | (c, g_c) ->
             let uu____17907 = FStar_TypeChecker_Common.is_total_lcomp lc in
             if uu____17907
             then
               let uu____17915 =
                 let uu____17917 = FStar_TypeChecker_Env.conj_guard g1 g_c in
                 discharge uu____17917 in
               (uu____17915, c)
             else
               (let steps =
                  [FStar_TypeChecker_Env.Beta;
                  FStar_TypeChecker_Env.NoFullNorm;
                  FStar_TypeChecker_Env.DoNotUnfoldPureLets] in
                let c1 =
                  let uu____17925 =
                    let uu____17926 =
                      FStar_TypeChecker_Env.unfold_effect_abbrev env c in
                    FStar_All.pipe_right uu____17926
                      FStar_Syntax_Syntax.mk_Comp in
                  FStar_All.pipe_right uu____17925
                    (FStar_TypeChecker_Normalize.normalize_comp steps env) in
                let uu____17927 = check_trivial_precondition env c1 in
                match uu____17927 with
                | (ct, vc, g_pre) ->
                    ((let uu____17943 =
                        FStar_All.pipe_left (FStar_TypeChecker_Env.debug env)
                          (FStar_Options.Other "Simplification") in
                      if uu____17943
                      then
                        let uu____17948 =
                          FStar_Syntax_Print.term_to_string vc in
                        FStar_Util.print1 "top-level VC: %s\n" uu____17948
                      else ());
                     (let uu____17953 =
                        let uu____17955 =
                          let uu____17956 =
                            FStar_TypeChecker_Env.conj_guard g_c g_pre in
                          FStar_TypeChecker_Env.conj_guard g1 uu____17956 in
                        discharge uu____17955 in
                      let uu____17957 =
                        FStar_All.pipe_right ct FStar_Syntax_Syntax.mk_Comp in
                      (uu____17953, uu____17957)))))
let (short_circuit :
  FStar_Syntax_Syntax.term ->
    FStar_Syntax_Syntax.args -> FStar_TypeChecker_Common.guard_formula)
  =
  fun head ->
    fun seen_args ->
      let short_bin_op f uu___8_17991 =
        match uu___8_17991 with
        | [] -> FStar_TypeChecker_Common.Trivial
        | (fst, uu____18001)::[] -> f fst
        | uu____18026 -> failwith "Unexpexted args to binary operator" in
      let op_and_e e =
        let uu____18038 = FStar_Syntax_Util.b2t e in
        FStar_All.pipe_right uu____18038
          (fun uu____18039 -> FStar_TypeChecker_Common.NonTrivial uu____18039) in
      let op_or_e e =
        let uu____18050 =
          let uu____18051 = FStar_Syntax_Util.b2t e in
          FStar_Syntax_Util.mk_neg uu____18051 in
        FStar_All.pipe_right uu____18050
          (fun uu____18054 -> FStar_TypeChecker_Common.NonTrivial uu____18054) in
      let op_and_t t =
        FStar_All.pipe_right t
          (fun uu____18061 -> FStar_TypeChecker_Common.NonTrivial uu____18061) in
      let op_or_t t =
        let uu____18072 = FStar_All.pipe_right t FStar_Syntax_Util.mk_neg in
        FStar_All.pipe_right uu____18072
          (fun uu____18075 -> FStar_TypeChecker_Common.NonTrivial uu____18075) in
      let op_imp_t t =
        FStar_All.pipe_right t
          (fun uu____18082 -> FStar_TypeChecker_Common.NonTrivial uu____18082) in
      let short_op_ite uu___9_18088 =
        match uu___9_18088 with
        | [] -> FStar_TypeChecker_Common.Trivial
        | (guard, uu____18098)::[] ->
            FStar_TypeChecker_Common.NonTrivial guard
        | _then::(guard, uu____18125)::[] ->
            let uu____18166 = FStar_Syntax_Util.mk_neg guard in
            FStar_All.pipe_right uu____18166
              (fun uu____18167 ->
                 FStar_TypeChecker_Common.NonTrivial uu____18167)
        | uu____18168 -> failwith "Unexpected args to ITE" in
      let table =
        let uu____18180 =
          let uu____18188 = short_bin_op op_and_e in
          (FStar_Parser_Const.op_And, uu____18188) in
        let uu____18196 =
          let uu____18206 =
            let uu____18214 = short_bin_op op_or_e in
            (FStar_Parser_Const.op_Or, uu____18214) in
          let uu____18222 =
            let uu____18232 =
              let uu____18240 = short_bin_op op_and_t in
              (FStar_Parser_Const.and_lid, uu____18240) in
            let uu____18248 =
              let uu____18258 =
                let uu____18266 = short_bin_op op_or_t in
                (FStar_Parser_Const.or_lid, uu____18266) in
              let uu____18274 =
                let uu____18284 =
                  let uu____18292 = short_bin_op op_imp_t in
                  (FStar_Parser_Const.imp_lid, uu____18292) in
                [uu____18284; (FStar_Parser_Const.ite_lid, short_op_ite)] in
              uu____18258 :: uu____18274 in
            uu____18232 :: uu____18248 in
          uu____18206 :: uu____18222 in
        uu____18180 :: uu____18196 in
      match head.FStar_Syntax_Syntax.n with
      | FStar_Syntax_Syntax.Tm_fvar fv ->
          let lid = (fv.FStar_Syntax_Syntax.fv_name).FStar_Syntax_Syntax.v in
          let uu____18354 =
            FStar_Util.find_map table
              (fun uu____18369 ->
                 match uu____18369 with
                 | (x, mk) ->
                     let uu____18386 = FStar_Ident.lid_equals x lid in
                     if uu____18386
                     then
                       let uu____18391 = mk seen_args in
                       FStar_Pervasives_Native.Some uu____18391
                     else FStar_Pervasives_Native.None) in
          (match uu____18354 with
           | FStar_Pervasives_Native.None -> FStar_TypeChecker_Common.Trivial
           | FStar_Pervasives_Native.Some g -> g)
      | uu____18395 -> FStar_TypeChecker_Common.Trivial
let (short_circuit_head : FStar_Syntax_Syntax.term -> Prims.bool) =
  fun l ->
    let uu____18403 =
      let uu____18404 = FStar_Syntax_Util.un_uinst l in
      uu____18404.FStar_Syntax_Syntax.n in
    match uu____18403 with
    | FStar_Syntax_Syntax.Tm_fvar fv ->
        FStar_Util.for_some (FStar_Syntax_Syntax.fv_eq_lid fv)
          [FStar_Parser_Const.op_And;
          FStar_Parser_Const.op_Or;
          FStar_Parser_Const.and_lid;
          FStar_Parser_Const.or_lid;
          FStar_Parser_Const.imp_lid;
          FStar_Parser_Const.ite_lid]
    | uu____18409 -> false
let (maybe_add_implicit_binders :
  FStar_TypeChecker_Env.env ->
    FStar_Syntax_Syntax.binders -> FStar_Syntax_Syntax.binders)
  =
  fun env ->
    fun bs ->
      let pos bs1 =
        match bs1 with
        | (hd, uu____18445)::uu____18446 ->
            FStar_Syntax_Syntax.range_of_bv hd
        | uu____18465 -> FStar_TypeChecker_Env.get_range env in
      match bs with
      | (uu____18474, FStar_Pervasives_Native.Some
         (FStar_Syntax_Syntax.Implicit uu____18475))::uu____18476 -> bs
      | uu____18494 ->
          let uu____18495 = FStar_TypeChecker_Env.expected_typ env in
          (match uu____18495 with
           | FStar_Pervasives_Native.None -> bs
           | FStar_Pervasives_Native.Some t ->
               let uu____18499 =
                 let uu____18500 = FStar_Syntax_Subst.compress t in
                 uu____18500.FStar_Syntax_Syntax.n in
               (match uu____18499 with
                | FStar_Syntax_Syntax.Tm_arrow (bs', uu____18504) ->
                    let uu____18525 =
                      FStar_Util.prefix_until
                        (fun uu___10_18565 ->
                           match uu___10_18565 with
                           | (uu____18573, FStar_Pervasives_Native.Some
                              (FStar_Syntax_Syntax.Implicit uu____18574)) ->
                               false
                           | uu____18579 -> true) bs' in
                    (match uu____18525 with
                     | FStar_Pervasives_Native.None -> bs
                     | FStar_Pervasives_Native.Some
                         ([], uu____18615, uu____18616) -> bs
                     | FStar_Pervasives_Native.Some
                         (imps, uu____18688, uu____18689) ->
                         let uu____18762 =
                           FStar_All.pipe_right imps
                             (FStar_Util.for_all
                                (fun uu____18783 ->
                                   match uu____18783 with
                                   | (x, uu____18792) ->
                                       let uu____18797 =
                                         FStar_Ident.string_of_id
                                           x.FStar_Syntax_Syntax.ppname in
                                       FStar_Util.starts_with uu____18797 "'")) in
                         if uu____18762
                         then
                           let r = pos bs in
                           let imps1 =
                             FStar_All.pipe_right imps
                               (FStar_List.map
                                  (fun uu____18843 ->
                                     match uu____18843 with
                                     | (x, i) ->
                                         let uu____18862 =
                                           FStar_Syntax_Syntax.set_range_of_bv
                                             x r in
                                         (uu____18862, i))) in
                           FStar_List.append imps1 bs
                         else bs)
                | uu____18873 -> bs))
let (maybe_lift :
  FStar_TypeChecker_Env.env ->
    FStar_Syntax_Syntax.term ->
      FStar_Ident.lident ->
        FStar_Ident.lident ->
          FStar_Syntax_Syntax.typ -> FStar_Syntax_Syntax.term)
  =
  fun env ->
    fun e ->
      fun c1 ->
        fun c2 ->
          fun t ->
            let m1 = FStar_TypeChecker_Env.norm_eff_name env c1 in
            let m2 = FStar_TypeChecker_Env.norm_eff_name env c2 in
            let uu____18902 =
              ((FStar_Ident.lid_equals m1 m2) ||
                 ((FStar_Syntax_Util.is_pure_effect c1) &&
                    (FStar_Syntax_Util.is_ghost_effect c2)))
                ||
                ((FStar_Syntax_Util.is_pure_effect c2) &&
                   (FStar_Syntax_Util.is_ghost_effect c1)) in
            if uu____18902
            then e
            else
              FStar_Syntax_Syntax.mk
                (FStar_Syntax_Syntax.Tm_meta
                   (e, (FStar_Syntax_Syntax.Meta_monadic_lift (m1, m2, t))))
                e.FStar_Syntax_Syntax.pos
let (maybe_monadic :
  FStar_TypeChecker_Env.env ->
    FStar_Syntax_Syntax.term ->
      FStar_Ident.lident ->
        FStar_Syntax_Syntax.typ -> FStar_Syntax_Syntax.term)
  =
  fun env ->
    fun e ->
      fun c ->
        fun t ->
          let m = FStar_TypeChecker_Env.norm_eff_name env c in
          let uu____18933 =
            ((is_pure_or_ghost_effect env m) ||
               (FStar_Ident.lid_equals m FStar_Parser_Const.effect_Tot_lid))
              ||
              (FStar_Ident.lid_equals m FStar_Parser_Const.effect_GTot_lid) in
          if uu____18933
          then e
          else
            FStar_Syntax_Syntax.mk
              (FStar_Syntax_Syntax.Tm_meta
                 (e, (FStar_Syntax_Syntax.Meta_monadic (m, t))))
              e.FStar_Syntax_Syntax.pos
let (d : Prims.string -> unit) =
  fun s -> FStar_Util.print1 "\027[01;36m%s\027[00m\n" s
let (mk_toplevel_definition :
  FStar_TypeChecker_Env.env ->
    FStar_Ident.lident ->
      FStar_Syntax_Syntax.term ->
        (FStar_Syntax_Syntax.sigelt * FStar_Syntax_Syntax.term))
  =
  fun env ->
    fun lident ->
      fun def ->
        (let uu____18976 =
           FStar_TypeChecker_Env.debug env (FStar_Options.Other "ED") in
         if uu____18976
         then
           ((let uu____18981 = FStar_Ident.string_of_lid lident in
             d uu____18981);
            (let uu____18983 = FStar_Ident.string_of_lid lident in
             let uu____18985 = FStar_Syntax_Print.term_to_string def in
             FStar_Util.print2 "Registering top-level definition: %s\n%s\n"
               uu____18983 uu____18985))
         else ());
        (let fv =
           let uu____18991 = FStar_Syntax_Util.incr_delta_qualifier def in
           FStar_Syntax_Syntax.lid_as_fv lident uu____18991
             FStar_Pervasives_Native.None in
         let lbname = FStar_Util.Inr fv in
         let lb =
           (false,
             [FStar_Syntax_Util.mk_letbinding lbname []
                FStar_Syntax_Syntax.tun FStar_Parser_Const.effect_Tot_lid def
                [] FStar_Range.dummyRange]) in
         let sig_ctx =
           FStar_Syntax_Syntax.mk_sigelt
             (FStar_Syntax_Syntax.Sig_let (lb, [lident])) in
         let uu____19003 =
           FStar_Syntax_Syntax.mk (FStar_Syntax_Syntax.Tm_fvar fv)
             FStar_Range.dummyRange in
         ((let uu___2181_19005 = sig_ctx in
           {
             FStar_Syntax_Syntax.sigel =
               (uu___2181_19005.FStar_Syntax_Syntax.sigel);
             FStar_Syntax_Syntax.sigrng =
               (uu___2181_19005.FStar_Syntax_Syntax.sigrng);
             FStar_Syntax_Syntax.sigquals =
               [FStar_Syntax_Syntax.Unfold_for_unification_and_vcgen];
             FStar_Syntax_Syntax.sigmeta =
               (uu___2181_19005.FStar_Syntax_Syntax.sigmeta);
             FStar_Syntax_Syntax.sigattrs =
               (uu___2181_19005.FStar_Syntax_Syntax.sigattrs);
             FStar_Syntax_Syntax.sigopts =
               (uu___2181_19005.FStar_Syntax_Syntax.sigopts)
           }), uu____19003))
let (check_sigelt_quals :
  FStar_TypeChecker_Env.env -> FStar_Syntax_Syntax.sigelt -> unit) =
  fun env ->
    fun se ->
      let visibility uu___11_19023 =
        match uu___11_19023 with
        | FStar_Syntax_Syntax.Private -> true
        | uu____19026 -> false in
      let reducibility uu___12_19034 =
        match uu___12_19034 with
        | FStar_Syntax_Syntax.Abstract -> true
        | FStar_Syntax_Syntax.Irreducible -> true
        | FStar_Syntax_Syntax.Unfold_for_unification_and_vcgen -> true
        | FStar_Syntax_Syntax.Visible_default -> true
        | FStar_Syntax_Syntax.Inline_for_extraction -> true
        | uu____19041 -> false in
      let assumption uu___13_19049 =
        match uu___13_19049 with
        | FStar_Syntax_Syntax.Assumption -> true
        | FStar_Syntax_Syntax.New -> true
        | uu____19053 -> false in
      let reification uu___14_19061 =
        match uu___14_19061 with
        | FStar_Syntax_Syntax.Reifiable -> true
        | FStar_Syntax_Syntax.Reflectable uu____19064 -> true
        | uu____19066 -> false in
      let inferred uu___15_19074 =
        match uu___15_19074 with
        | FStar_Syntax_Syntax.Discriminator uu____19076 -> true
        | FStar_Syntax_Syntax.Projector uu____19078 -> true
        | FStar_Syntax_Syntax.RecordType uu____19084 -> true
        | FStar_Syntax_Syntax.RecordConstructor uu____19094 -> true
        | FStar_Syntax_Syntax.ExceptionConstructor -> true
        | FStar_Syntax_Syntax.HasMaskedEffect -> true
        | FStar_Syntax_Syntax.Effect -> true
        | uu____19107 -> false in
      let has_eq uu___16_19115 =
        match uu___16_19115 with
        | FStar_Syntax_Syntax.Noeq -> true
        | FStar_Syntax_Syntax.Unopteq -> true
        | uu____19119 -> false in
      let quals_combo_ok quals q =
        match q with
        | FStar_Syntax_Syntax.Assumption ->
            FStar_All.pipe_right quals
              (FStar_List.for_all
                 (fun x ->
                    ((((((x = q) || (x = FStar_Syntax_Syntax.Logic)) ||
                          (inferred x))
                         || (visibility x))
                        || (assumption x))
                       ||
                       (env.FStar_TypeChecker_Env.is_iface &&
                          (x = FStar_Syntax_Syntax.Inline_for_extraction)))
                      || (x = FStar_Syntax_Syntax.NoExtract)))
        | FStar_Syntax_Syntax.New ->
            FStar_All.pipe_right quals
              (FStar_List.for_all
                 (fun x ->
                    (((x = q) || (inferred x)) || (visibility x)) ||
                      (assumption x)))
        | FStar_Syntax_Syntax.Inline_for_extraction ->
            FStar_All.pipe_right quals
              (FStar_List.for_all
                 (fun x ->
                    ((((((((x = q) || (x = FStar_Syntax_Syntax.Logic)) ||
                            (visibility x))
                           || (reducibility x))
                          || (reification x))
                         || (inferred x))
                        || (has_eq x))
                       ||
                       (env.FStar_TypeChecker_Env.is_iface &&
                          (x = FStar_Syntax_Syntax.Assumption)))
                      || (x = FStar_Syntax_Syntax.NoExtract)))
        | FStar_Syntax_Syntax.Unfold_for_unification_and_vcgen ->
            FStar_All.pipe_right quals
              (FStar_List.for_all
                 (fun x ->
                    ((((((((x = q) || (x = FStar_Syntax_Syntax.Logic)) ||
                            (x = FStar_Syntax_Syntax.Abstract))
                           || (x = FStar_Syntax_Syntax.Inline_for_extraction))
                          || (x = FStar_Syntax_Syntax.NoExtract))
                         || (has_eq x))
                        || (inferred x))
                       || (visibility x))
                      || (reification x)))
        | FStar_Syntax_Syntax.Visible_default ->
            FStar_All.pipe_right quals
              (FStar_List.for_all
                 (fun x ->
                    ((((((((x = q) || (x = FStar_Syntax_Syntax.Logic)) ||
                            (x = FStar_Syntax_Syntax.Abstract))
                           || (x = FStar_Syntax_Syntax.Inline_for_extraction))
                          || (x = FStar_Syntax_Syntax.NoExtract))
                         || (has_eq x))
                        || (inferred x))
                       || (visibility x))
                      || (reification x)))
        | FStar_Syntax_Syntax.Irreducible ->
            FStar_All.pipe_right quals
              (FStar_List.for_all
                 (fun x ->
                    ((((((((x = q) || (x = FStar_Syntax_Syntax.Logic)) ||
                            (x = FStar_Syntax_Syntax.Abstract))
                           || (x = FStar_Syntax_Syntax.Inline_for_extraction))
                          || (x = FStar_Syntax_Syntax.NoExtract))
                         || (has_eq x))
                        || (inferred x))
                       || (visibility x))
                      || (reification x)))
        | FStar_Syntax_Syntax.Abstract ->
            FStar_All.pipe_right quals
              (FStar_List.for_all
                 (fun x ->
                    ((((((((x = q) || (x = FStar_Syntax_Syntax.Logic)) ||
                            (x = FStar_Syntax_Syntax.Abstract))
                           || (x = FStar_Syntax_Syntax.Inline_for_extraction))
                          || (x = FStar_Syntax_Syntax.NoExtract))
                         || (has_eq x))
                        || (inferred x))
                       || (visibility x))
                      || (reification x)))
        | FStar_Syntax_Syntax.Noeq ->
            FStar_All.pipe_right quals
              (FStar_List.for_all
                 (fun x ->
                    ((((((((x = q) || (x = FStar_Syntax_Syntax.Logic)) ||
                            (x = FStar_Syntax_Syntax.Abstract))
                           || (x = FStar_Syntax_Syntax.Inline_for_extraction))
                          || (x = FStar_Syntax_Syntax.NoExtract))
                         || (has_eq x))
                        || (inferred x))
                       || (visibility x))
                      || (reification x)))
        | FStar_Syntax_Syntax.Unopteq ->
            FStar_All.pipe_right quals
              (FStar_List.for_all
                 (fun x ->
                    ((((((((x = q) || (x = FStar_Syntax_Syntax.Logic)) ||
                            (x = FStar_Syntax_Syntax.Abstract))
                           || (x = FStar_Syntax_Syntax.Inline_for_extraction))
                          || (x = FStar_Syntax_Syntax.NoExtract))
                         || (has_eq x))
                        || (inferred x))
                       || (visibility x))
                      || (reification x)))
        | FStar_Syntax_Syntax.TotalEffect ->
            FStar_All.pipe_right quals
              (FStar_List.for_all
                 (fun x ->
                    (((x = q) || (inferred x)) || (visibility x)) ||
                      (reification x)))
        | FStar_Syntax_Syntax.Logic ->
            FStar_All.pipe_right quals
              (FStar_List.for_all
                 (fun x ->
                    ((((x = q) || (x = FStar_Syntax_Syntax.Assumption)) ||
                        (inferred x))
                       || (visibility x))
                      || (reducibility x)))
        | FStar_Syntax_Syntax.Reifiable ->
            FStar_All.pipe_right quals
              (FStar_List.for_all
                 (fun x ->
                    ((((reification x) || (inferred x)) || (visibility x)) ||
                       (x = FStar_Syntax_Syntax.TotalEffect))
                      || (x = FStar_Syntax_Syntax.Visible_default)))
        | FStar_Syntax_Syntax.Reflectable uu____19198 ->
            FStar_All.pipe_right quals
              (FStar_List.for_all
                 (fun x ->
                    ((((reification x) || (inferred x)) || (visibility x)) ||
                       (x = FStar_Syntax_Syntax.TotalEffect))
                      || (x = FStar_Syntax_Syntax.Visible_default)))
        | FStar_Syntax_Syntax.Private -> true
        | uu____19205 -> true in
      let check_erasable quals se1 r =
        let lids = FStar_Syntax_Util.lids_of_sigelt se1 in
        let val_exists =
          FStar_All.pipe_right lids
            (FStar_Util.for_some
               (fun l ->
                  let uu____19238 =
                    FStar_TypeChecker_Env.try_lookup_val_decl env l in
                  FStar_Option.isSome uu____19238)) in
        let val_has_erasable_attr =
          FStar_All.pipe_right lids
            (FStar_Util.for_some
               (fun l ->
                  let attrs_opt =
                    FStar_TypeChecker_Env.lookup_attrs_of_lid env l in
                  (FStar_Option.isSome attrs_opt) &&
                    (let uu____19269 = FStar_Option.get attrs_opt in
                     FStar_Syntax_Util.has_attribute uu____19269
                       FStar_Parser_Const.erasable_attr))) in
        let se_has_erasable_attr =
          FStar_Syntax_Util.has_attribute se1.FStar_Syntax_Syntax.sigattrs
            FStar_Parser_Const.erasable_attr in
        if
          (val_exists && val_has_erasable_attr) &&
            (Prims.op_Negation se_has_erasable_attr)
        then
          FStar_Errors.raise_error
            (FStar_Errors.Fatal_QulifierListNotPermitted,
              "Mismatch of attributes between declaration and definition: Declaration is marked `erasable` but the definition is not")
            r
        else ();
        if
          (val_exists && (Prims.op_Negation val_has_erasable_attr)) &&
            se_has_erasable_attr
        then
          FStar_Errors.raise_error
            (FStar_Errors.Fatal_QulifierListNotPermitted,
              "Mismatch of attributed between declaration and definition: Definition is marked `erasable` but the declaration is not")
            r
        else ();
        if se_has_erasable_attr
        then
          (match se1.FStar_Syntax_Syntax.sigel with
           | FStar_Syntax_Syntax.Sig_bundle uu____19289 ->
               let uu____19298 =
                 let uu____19300 =
                   FStar_All.pipe_right quals
                     (FStar_Util.for_some
                        (fun uu___17_19306 ->
                           match uu___17_19306 with
                           | FStar_Syntax_Syntax.Noeq -> true
                           | uu____19309 -> false)) in
                 Prims.op_Negation uu____19300 in
               if uu____19298
               then
                 FStar_Errors.raise_error
                   (FStar_Errors.Fatal_QulifierListNotPermitted,
                     "Incompatible attributes and qualifiers: erasable types do not support decidable equality and must be marked `noeq`")
                   r
               else ()
           | FStar_Syntax_Syntax.Sig_declare_typ uu____19316 -> ()
           | FStar_Syntax_Syntax.Sig_fail uu____19323 -> ()
           | uu____19336 ->
               FStar_Errors.raise_error
                 (FStar_Errors.Fatal_QulifierListNotPermitted,
                   "Illegal attribute: the `erasable` attribute is only permitted on inductive type definitions")
                 r)
        else () in
      let quals =
        FStar_All.pipe_right (FStar_Syntax_Util.quals_of_sigelt se)
          (FStar_List.filter
             (fun x -> Prims.op_Negation (x = FStar_Syntax_Syntax.Logic))) in
      let uu____19350 =
        let uu____19352 =
          FStar_All.pipe_right quals
            (FStar_Util.for_some
               (fun uu___18_19358 ->
                  match uu___18_19358 with
                  | FStar_Syntax_Syntax.OnlyName -> true
                  | uu____19361 -> false)) in
        FStar_All.pipe_right uu____19352 Prims.op_Negation in
      if uu____19350
      then
        let r = FStar_Syntax_Util.range_of_sigelt se in
        let no_dup_quals =
          FStar_Util.remove_dups (fun x -> fun y -> x = y) quals in
        let err' msg =
          let uu____19382 =
            let uu____19388 =
              let uu____19390 = FStar_Syntax_Print.quals_to_string quals in
              FStar_Util.format2
                "The qualifier list \"[%s]\" is not permissible for this element%s"
                uu____19390 msg in
            (FStar_Errors.Fatal_QulifierListNotPermitted, uu____19388) in
          FStar_Errors.raise_error uu____19382 r in
        let err msg = err' (Prims.op_Hat ": " msg) in
        let err'1 uu____19408 = err' "" in
        (if (FStar_List.length quals) <> (FStar_List.length no_dup_quals)
         then err "duplicate qualifiers"
         else ();
         (let uu____19416 =
            let uu____19418 =
              FStar_All.pipe_right quals
                (FStar_List.for_all (quals_combo_ok quals)) in
            Prims.op_Negation uu____19418 in
          if uu____19416 then err "ill-formed combination" else ());
         check_erasable quals se r;
         (match se.FStar_Syntax_Syntax.sigel with
          | FStar_Syntax_Syntax.Sig_let ((is_rec, uu____19429), uu____19430)
              ->
              ((let uu____19442 =
                  is_rec &&
                    (FStar_All.pipe_right quals
                       (FStar_List.contains
                          FStar_Syntax_Syntax.Unfold_for_unification_and_vcgen)) in
                if uu____19442
                then err "recursive definitions cannot be marked inline"
                else ());
               (let uu____19451 =
                  FStar_All.pipe_right quals
                    (FStar_Util.for_some
                       (fun x -> (assumption x) || (has_eq x))) in
                if uu____19451
                then
                  err
                    "definitions cannot be assumed or marked with equality qualifiers"
                else ()))
          | FStar_Syntax_Syntax.Sig_bundle uu____19462 ->
              ((let uu____19472 =
                  let uu____19474 =
                    FStar_All.pipe_right quals
                      (FStar_Util.for_all
                         (fun x ->
                            (((((x = FStar_Syntax_Syntax.Abstract) ||
                                  (x =
                                     FStar_Syntax_Syntax.Inline_for_extraction))
                                 || (x = FStar_Syntax_Syntax.NoExtract))
                                || (inferred x))
                               || (visibility x))
                              || (has_eq x))) in
                  Prims.op_Negation uu____19474 in
                if uu____19472 then err'1 () else ());
               (let uu____19484 =
                  (FStar_All.pipe_right quals
                     (FStar_List.existsb
                        (fun uu___19_19490 ->
                           match uu___19_19490 with
                           | FStar_Syntax_Syntax.Unopteq -> true
                           | uu____19493 -> false)))
                    &&
                    (FStar_Syntax_Util.has_attribute
                       se.FStar_Syntax_Syntax.sigattrs
                       FStar_Parser_Const.erasable_attr) in
                if uu____19484
                then
                  err
                    "unopteq is not allowed on an erasable inductives since they don't have decidable equality"
                else ()))
          | FStar_Syntax_Syntax.Sig_declare_typ uu____19499 ->
              let uu____19506 =
                FStar_All.pipe_right quals (FStar_Util.for_some has_eq) in
              if uu____19506 then err'1 () else ()
          | FStar_Syntax_Syntax.Sig_assume uu____19514 ->
              let uu____19521 =
                let uu____19523 =
                  FStar_All.pipe_right quals
                    (FStar_Util.for_all
                       (fun x ->
                          (visibility x) ||
                            (x = FStar_Syntax_Syntax.Assumption))) in
                Prims.op_Negation uu____19523 in
              if uu____19521 then err'1 () else ()
          | FStar_Syntax_Syntax.Sig_new_effect uu____19533 ->
              let uu____19534 =
                let uu____19536 =
                  FStar_All.pipe_right quals
                    (FStar_Util.for_all
                       (fun x ->
                          (((x = FStar_Syntax_Syntax.TotalEffect) ||
                              (inferred x))
                             || (visibility x))
                            || (reification x))) in
                Prims.op_Negation uu____19536 in
              if uu____19534 then err'1 () else ()
          | FStar_Syntax_Syntax.Sig_effect_abbrev uu____19546 ->
              let uu____19559 =
                let uu____19561 =
                  FStar_All.pipe_right quals
                    (FStar_Util.for_all
                       (fun x -> (inferred x) || (visibility x))) in
                Prims.op_Negation uu____19561 in
              if uu____19559 then err'1 () else ()
          | uu____19571 -> ()))
      else ()
let (must_erase_for_extraction :
  FStar_TypeChecker_Env.env -> FStar_Syntax_Syntax.term -> Prims.bool) =
  fun g ->
    fun t ->
      let rec descend env t1 =
        let uu____19610 =
          let uu____19611 = FStar_Syntax_Subst.compress t1 in
          uu____19611.FStar_Syntax_Syntax.n in
        match uu____19610 with
        | FStar_Syntax_Syntax.Tm_arrow uu____19615 ->
            let uu____19630 = FStar_Syntax_Util.arrow_formals_comp t1 in
            (match uu____19630 with
             | (bs, c) ->
                 let env1 = FStar_TypeChecker_Env.push_binders env bs in
                 (FStar_Syntax_Util.is_ghost_effect
                    (FStar_Syntax_Util.comp_effect_name c))
                   ||
                   ((FStar_Syntax_Util.is_pure_or_ghost_comp c) &&
                      (aux env1 (FStar_Syntax_Util.comp_result c))))
        | FStar_Syntax_Syntax.Tm_refine
            ({ FStar_Syntax_Syntax.ppname = uu____19639;
               FStar_Syntax_Syntax.index = uu____19640;
               FStar_Syntax_Syntax.sort = t2;_},
             uu____19642)
            -> aux env t2
        | FStar_Syntax_Syntax.Tm_app (head, uu____19651) -> descend env head
        | FStar_Syntax_Syntax.Tm_uinst (head, uu____19677) ->
            descend env head
        | FStar_Syntax_Syntax.Tm_fvar fv ->
            FStar_TypeChecker_Env.fv_has_attr env fv
              FStar_Parser_Const.must_erase_for_extraction_attr
        | uu____19683 -> false
      and aux env t1 =
        let t2 =
          FStar_TypeChecker_Normalize.normalize
            [FStar_TypeChecker_Env.Primops;
            FStar_TypeChecker_Env.Weak;
            FStar_TypeChecker_Env.HNF;
            FStar_TypeChecker_Env.UnfoldUntil
              FStar_Syntax_Syntax.delta_constant;
            FStar_TypeChecker_Env.Beta;
            FStar_TypeChecker_Env.AllowUnboundUniverses;
            FStar_TypeChecker_Env.Zeta;
            FStar_TypeChecker_Env.Iota;
            FStar_TypeChecker_Env.Unascribe] env t1 in
        let res =
          (FStar_TypeChecker_Env.non_informative env t2) || (descend env t2) in
        (let uu____19693 =
           FStar_All.pipe_left (FStar_TypeChecker_Env.debug env)
             (FStar_Options.Other "Extraction") in
         if uu____19693
         then
           let uu____19698 = FStar_Syntax_Print.term_to_string t2 in
           FStar_Util.print2 "must_erase=%s: %s\n"
             (if res then "true" else "false") uu____19698
         else ());
        res in
      aux g t
let (fresh_effect_repr :
  FStar_TypeChecker_Env.env ->
    FStar_Range.range ->
      FStar_Ident.lident ->
        FStar_Syntax_Syntax.tscheme ->
          FStar_Syntax_Syntax.tscheme FStar_Pervasives_Native.option ->
            FStar_Syntax_Syntax.universe ->
              FStar_Syntax_Syntax.term ->
                (FStar_Syntax_Syntax.term * FStar_TypeChecker_Common.guard_t))
  =
  fun env ->
    fun r ->
      fun eff_name ->
        fun signature_ts ->
          fun repr_ts_opt ->
            fun u ->
              fun a_tm ->
                let fail t =
                  let uu____19763 =
                    FStar_TypeChecker_Err.unexpected_signature_for_monad env
                      eff_name t in
                  FStar_Errors.raise_error uu____19763 r in
                let uu____19773 =
                  FStar_TypeChecker_Env.inst_tscheme signature_ts in
                match uu____19773 with
                | (uu____19782, signature) ->
                    let uu____19784 =
                      let uu____19785 = FStar_Syntax_Subst.compress signature in
                      uu____19785.FStar_Syntax_Syntax.n in
                    (match uu____19784 with
                     | FStar_Syntax_Syntax.Tm_arrow (bs, uu____19793) ->
                         let bs1 = FStar_Syntax_Subst.open_binders bs in
                         (match bs1 with
                          | a::bs2 ->
                              let uu____19841 =
                                FStar_TypeChecker_Env.uvars_for_binders env
                                  bs2
                                  [FStar_Syntax_Syntax.NT
                                     ((FStar_Pervasives_Native.fst a), a_tm)]
                                  (fun b ->
                                     let uu____19857 =
                                       FStar_Syntax_Print.binder_to_string b in
                                     let uu____19859 =
                                       FStar_Ident.string_of_lid eff_name in
                                     let uu____19861 =
                                       FStar_Range.string_of_range r in
                                     FStar_Util.format3
                                       "uvar for binder %s when creating a fresh repr for %s at %s"
                                       uu____19857 uu____19859 uu____19861) r in
                              (match uu____19841 with
                               | (is, g) ->
                                   let uu____19874 =
                                     match repr_ts_opt with
                                     | FStar_Pervasives_Native.None ->
                                         let eff_c =
                                           let uu____19876 =
                                             let uu____19877 =
                                               FStar_List.map
                                                 FStar_Syntax_Syntax.as_arg
                                                 is in
                                             {
                                               FStar_Syntax_Syntax.comp_univs
                                                 = [u];
                                               FStar_Syntax_Syntax.effect_name
                                                 = eff_name;
                                               FStar_Syntax_Syntax.result_typ
                                                 = a_tm;
                                               FStar_Syntax_Syntax.effect_args
                                                 = uu____19877;
                                               FStar_Syntax_Syntax.flags = []
                                             } in
                                           FStar_Syntax_Syntax.mk_Comp
                                             uu____19876 in
                                         let uu____19896 =
                                           let uu____19897 =
                                             let uu____19912 =
                                               let uu____19921 =
                                                 FStar_Syntax_Syntax.null_binder
                                                   FStar_Syntax_Syntax.t_unit in
                                               [uu____19921] in
                                             (uu____19912, eff_c) in
                                           FStar_Syntax_Syntax.Tm_arrow
                                             uu____19897 in
                                         FStar_Syntax_Syntax.mk uu____19896 r
                                     | FStar_Pervasives_Native.Some repr_ts
                                         ->
                                         let repr =
                                           let uu____19952 =
                                             FStar_TypeChecker_Env.inst_tscheme_with
                                               repr_ts [u] in
                                           FStar_All.pipe_right uu____19952
                                             FStar_Pervasives_Native.snd in
                                         let uu____19961 =
                                           FStar_List.map
                                             FStar_Syntax_Syntax.as_arg (a_tm
                                             :: is) in
                                         FStar_Syntax_Syntax.mk_Tm_app repr
                                           uu____19961 r in
                                   (uu____19874, g))
                          | uu____19970 -> fail signature)
                     | uu____19971 -> fail signature)
let (fresh_effect_repr_en :
  FStar_TypeChecker_Env.env ->
    FStar_Range.range ->
      FStar_Ident.lident ->
        FStar_Syntax_Syntax.universe ->
          FStar_Syntax_Syntax.term ->
            (FStar_Syntax_Syntax.term * FStar_TypeChecker_Common.guard_t))
  =
  fun env ->
    fun r ->
      fun eff_name ->
        fun u ->
          fun a_tm ->
            let uu____20002 =
              FStar_All.pipe_right eff_name
                (FStar_TypeChecker_Env.get_effect_decl env) in
            FStar_All.pipe_right uu____20002
              (fun ed ->
                 let uu____20010 =
                   FStar_All.pipe_right ed FStar_Syntax_Util.get_eff_repr in
                 fresh_effect_repr env r eff_name
                   ed.FStar_Syntax_Syntax.signature uu____20010 u a_tm)
let (layered_effect_indices_as_binders :
  FStar_TypeChecker_Env.env ->
    FStar_Range.range ->
      FStar_Ident.lident ->
        FStar_Syntax_Syntax.tscheme ->
          FStar_Syntax_Syntax.universe ->
            FStar_Syntax_Syntax.term -> FStar_Syntax_Syntax.binders)
  =
  fun env ->
    fun r ->
      fun eff_name ->
        fun sig_ts ->
          fun u ->
            fun a_tm ->
              let uu____20046 =
                FStar_TypeChecker_Env.inst_tscheme_with sig_ts [u] in
              match uu____20046 with
              | (uu____20051, sig_tm) ->
                  let fail t =
                    let uu____20059 =
                      FStar_TypeChecker_Err.unexpected_signature_for_monad
                        env eff_name t in
                    FStar_Errors.raise_error uu____20059 r in
                  let uu____20065 =
                    let uu____20066 = FStar_Syntax_Subst.compress sig_tm in
                    uu____20066.FStar_Syntax_Syntax.n in
                  (match uu____20065 with
                   | FStar_Syntax_Syntax.Tm_arrow (bs, uu____20070) ->
                       let bs1 = FStar_Syntax_Subst.open_binders bs in
                       (match bs1 with
                        | (a', uu____20093)::bs2 ->
                            FStar_All.pipe_right bs2
                              (FStar_Syntax_Subst.subst_binders
                                 [FStar_Syntax_Syntax.NT (a', a_tm)])
                        | uu____20115 -> fail sig_tm)
                   | uu____20116 -> fail sig_tm)
let (lift_tf_layered_effect :
  FStar_Ident.lident ->
    FStar_Syntax_Syntax.tscheme ->
      FStar_TypeChecker_Env.env ->
        FStar_Syntax_Syntax.comp ->
          (FStar_Syntax_Syntax.comp * FStar_TypeChecker_Common.guard_t))
  =
  fun tgt ->
    fun lift_ts ->
      fun env ->
        fun c ->
          (let uu____20147 =
             FStar_All.pipe_left (FStar_TypeChecker_Env.debug env)
               (FStar_Options.Other "LayeredEffects") in
           if uu____20147
           then
             let uu____20152 = FStar_Syntax_Print.comp_to_string c in
             let uu____20154 = FStar_Syntax_Print.lid_to_string tgt in
             FStar_Util.print2 "Lifting comp %s to layered effect %s {\n"
               uu____20152 uu____20154
           else ());
          (let r = FStar_TypeChecker_Env.get_range env in
           let ct = FStar_Syntax_Util.comp_to_comp_typ c in
           let uu____20161 =
             let uu____20172 =
               FStar_List.hd ct.FStar_Syntax_Syntax.comp_univs in
             let uu____20173 =
               FStar_All.pipe_right ct.FStar_Syntax_Syntax.effect_args
                 (FStar_List.map FStar_Pervasives_Native.fst) in
             (uu____20172, (ct.FStar_Syntax_Syntax.result_typ), uu____20173) in
           match uu____20161 with
           | (u, a, c_is) ->
               let uu____20221 =
                 FStar_TypeChecker_Env.inst_tscheme_with lift_ts [u] in
               (match uu____20221 with
                | (uu____20230, lift_t) ->
                    let lift_t_shape_error s =
                      let uu____20241 =
                        FStar_Ident.string_of_lid
                          ct.FStar_Syntax_Syntax.effect_name in
                      let uu____20243 = FStar_Ident.string_of_lid tgt in
                      let uu____20245 =
                        FStar_Syntax_Print.term_to_string lift_t in
                      FStar_Util.format4
                        "Lift from %s to %s has unexpected shape, reason: %s (lift:%s)"
                        uu____20241 uu____20243 s uu____20245 in
                    let uu____20248 =
                      let uu____20281 =
                        let uu____20282 = FStar_Syntax_Subst.compress lift_t in
                        uu____20282.FStar_Syntax_Syntax.n in
                      match uu____20281 with
                      | FStar_Syntax_Syntax.Tm_arrow (bs, c1) when
                          (FStar_List.length bs) >= (Prims.of_int (2)) ->
                          let uu____20346 =
                            FStar_Syntax_Subst.open_comp bs c1 in
                          (match uu____20346 with
                           | (a_b::bs1, c2) ->
                               let uu____20406 =
                                 FStar_All.pipe_right bs1
                                   (FStar_List.splitAt
                                      ((FStar_List.length bs1) -
                                         Prims.int_one)) in
                               (a_b, uu____20406, c2))
                      | uu____20494 ->
                          let uu____20495 =
                            let uu____20501 =
                              lift_t_shape_error
                                "either not an arrow or not enough binders" in
                            (FStar_Errors.Fatal_UnexpectedEffect,
                              uu____20501) in
                          FStar_Errors.raise_error uu____20495 r in
                    (match uu____20248 with
                     | (a_b, (rest_bs, f_b::[]), lift_c) ->
                         let uu____20619 =
                           let uu____20626 =
                             let uu____20627 =
                               let uu____20628 =
                                 let uu____20635 =
                                   FStar_All.pipe_right a_b
                                     FStar_Pervasives_Native.fst in
                                 (uu____20635, a) in
                               FStar_Syntax_Syntax.NT uu____20628 in
                             [uu____20627] in
                           FStar_TypeChecker_Env.uvars_for_binders env
                             rest_bs uu____20626
                             (fun b ->
                                let uu____20652 =
                                  FStar_Syntax_Print.binder_to_string b in
                                let uu____20654 =
                                  FStar_Ident.string_of_lid
                                    ct.FStar_Syntax_Syntax.effect_name in
                                let uu____20656 =
                                  FStar_Ident.string_of_lid tgt in
                                let uu____20658 =
                                  FStar_Range.string_of_range r in
                                FStar_Util.format4
                                  "implicit var for binder %s of %s~>%s at %s"
                                  uu____20652 uu____20654 uu____20656
                                  uu____20658) r in
                         (match uu____20619 with
                          | (rest_bs_uvars, g) ->
                              ((let uu____20672 =
                                  FStar_All.pipe_left
                                    (FStar_TypeChecker_Env.debug env)
                                    (FStar_Options.Other "LayeredEffects") in
                                if uu____20672
                                then
                                  let uu____20677 =
                                    FStar_List.fold_left
                                      (fun s ->
                                         fun u1 ->
                                           let uu____20686 =
                                             let uu____20688 =
                                               FStar_Syntax_Print.term_to_string
                                                 u1 in
                                             Prims.op_Hat ";;;;" uu____20688 in
                                           Prims.op_Hat s uu____20686) ""
                                      rest_bs_uvars in
                                  FStar_Util.print1 "Introduced uvars: %s\n"
                                    uu____20677
                                else ());
                               (let substs =
                                  FStar_List.map2
                                    (fun b ->
                                       fun t ->
                                         let uu____20719 =
                                           let uu____20726 =
                                             FStar_All.pipe_right b
                                               FStar_Pervasives_Native.fst in
                                           (uu____20726, t) in
                                         FStar_Syntax_Syntax.NT uu____20719)
                                    (a_b :: rest_bs) (a :: rest_bs_uvars) in
                                let guard_f =
                                  let f_sort =
                                    let uu____20745 =
                                      FStar_All.pipe_right
                                        (FStar_Pervasives_Native.fst f_b).FStar_Syntax_Syntax.sort
                                        (FStar_Syntax_Subst.subst substs) in
                                    FStar_All.pipe_right uu____20745
                                      FStar_Syntax_Subst.compress in
                                  let f_sort_is =
                                    let uu____20751 =
                                      FStar_TypeChecker_Env.is_layered_effect
                                        env
                                        ct.FStar_Syntax_Syntax.effect_name in
                                    effect_args_from_repr f_sort uu____20751
                                      r in
                                  FStar_List.fold_left2
                                    (fun g1 ->
                                       fun i1 ->
                                         fun i2 ->
                                           let uu____20760 =
                                             FStar_TypeChecker_Rel.teq env i1
                                               i2 in
                                           FStar_TypeChecker_Env.conj_guard
                                             g1 uu____20760)
                                    FStar_TypeChecker_Env.trivial_guard c_is
                                    f_sort_is in
                                let lift_ct =
                                  let uu____20762 =
                                    FStar_All.pipe_right lift_c
                                      (FStar_Syntax_Subst.subst_comp substs) in
                                  FStar_All.pipe_right uu____20762
                                    FStar_Syntax_Util.comp_to_comp_typ in
                                let is =
                                  let uu____20766 =
                                    FStar_TypeChecker_Env.is_layered_effect
                                      env tgt in
                                  effect_args_from_repr
                                    lift_ct.FStar_Syntax_Syntax.result_typ
                                    uu____20766 r in
                                let fml =
                                  let uu____20771 =
                                    let uu____20776 =
                                      FStar_List.hd
                                        lift_ct.FStar_Syntax_Syntax.comp_univs in
                                    let uu____20777 =
                                      let uu____20778 =
                                        FStar_List.hd
                                          lift_ct.FStar_Syntax_Syntax.effect_args in
                                      FStar_Pervasives_Native.fst uu____20778 in
                                    (uu____20776, uu____20777) in
                                  match uu____20771 with
                                  | (u1, wp) ->
                                      FStar_TypeChecker_Env.pure_precondition_for_trivial_post
                                        env u1
                                        lift_ct.FStar_Syntax_Syntax.result_typ
                                        wp FStar_Range.dummyRange in
                                (let uu____20804 =
                                   (FStar_All.pipe_left
                                      (FStar_TypeChecker_Env.debug env)
                                      (FStar_Options.Other "LayeredEffects"))
                                     &&
                                     (FStar_All.pipe_left
                                        (FStar_TypeChecker_Env.debug env)
                                        FStar_Options.Extreme) in
                                 if uu____20804
                                 then
                                   let uu____20810 =
                                     FStar_Syntax_Print.term_to_string fml in
                                   FStar_Util.print1 "Guard for lift is: %s"
                                     uu____20810
                                 else ());
                                (let c1 =
                                   let uu____20816 =
                                     let uu____20817 =
                                       FStar_All.pipe_right is
                                         (FStar_List.map
                                            FStar_Syntax_Syntax.as_arg) in
                                     {
                                       FStar_Syntax_Syntax.comp_univs =
                                         (lift_ct.FStar_Syntax_Syntax.comp_univs);
                                       FStar_Syntax_Syntax.effect_name = tgt;
                                       FStar_Syntax_Syntax.result_typ = a;
                                       FStar_Syntax_Syntax.effect_args =
                                         uu____20817;
                                       FStar_Syntax_Syntax.flags = []
                                     } in
                                   FStar_Syntax_Syntax.mk_Comp uu____20816 in
                                 (let uu____20841 =
                                    FStar_All.pipe_left
                                      (FStar_TypeChecker_Env.debug env)
                                      (FStar_Options.Other "LayeredEffects") in
                                  if uu____20841
                                  then
                                    let uu____20846 =
                                      FStar_Syntax_Print.comp_to_string c1 in
                                    FStar_Util.print1 "} Lifted comp: %s\n"
                                      uu____20846
                                  else ());
                                 (let uu____20851 =
                                    let uu____20852 =
                                      FStar_TypeChecker_Env.conj_guard g
                                        guard_f in
                                    let uu____20853 =
                                      FStar_TypeChecker_Env.guard_of_guard_formula
                                        (FStar_TypeChecker_Common.NonTrivial
                                           fml) in
                                    FStar_TypeChecker_Env.conj_guard
                                      uu____20852 uu____20853 in
                                  (c1, uu____20851)))))))))
let lift_tf_layered_effect_term :
  'uuuuuu20867 .
    'uuuuuu20867 ->
      FStar_Syntax_Syntax.sub_eff ->
        FStar_Syntax_Syntax.universe ->
          FStar_Syntax_Syntax.typ ->
            FStar_Syntax_Syntax.term -> FStar_Syntax_Syntax.term
  =
  fun env ->
    fun sub ->
      fun u ->
        fun a ->
          fun e ->
            let lift =
              let uu____20896 =
                let uu____20901 =
                  FStar_All.pipe_right sub.FStar_Syntax_Syntax.lift
                    FStar_Util.must in
                FStar_All.pipe_right uu____20901
                  (fun ts -> FStar_TypeChecker_Env.inst_tscheme_with ts [u]) in
              FStar_All.pipe_right uu____20896 FStar_Pervasives_Native.snd in
            let rest_bs =
              let lift_t =
                FStar_All.pipe_right sub.FStar_Syntax_Syntax.lift_wp
                  FStar_Util.must in
              let uu____20944 =
                let uu____20945 =
                  let uu____20948 =
                    FStar_All.pipe_right lift_t FStar_Pervasives_Native.snd in
                  FStar_All.pipe_right uu____20948
                    FStar_Syntax_Subst.compress in
                uu____20945.FStar_Syntax_Syntax.n in
              match uu____20944 with
              | FStar_Syntax_Syntax.Tm_arrow (uu____20971::bs, uu____20973)
                  when (FStar_List.length bs) >= Prims.int_one ->
                  let uu____21013 =
                    FStar_All.pipe_right bs
                      (FStar_List.splitAt
                         ((FStar_List.length bs) - Prims.int_one)) in
                  FStar_All.pipe_right uu____21013
                    FStar_Pervasives_Native.fst
              | uu____21119 ->
                  let uu____21120 =
                    let uu____21126 =
                      let uu____21128 =
                        FStar_Syntax_Print.tscheme_to_string lift_t in
                      FStar_Util.format1
                        "lift_t tscheme %s is not an arrow with enough binders"
                        uu____21128 in
                    (FStar_Errors.Fatal_UnexpectedEffect, uu____21126) in
                  FStar_Errors.raise_error uu____21120
                    (FStar_Pervasives_Native.snd lift_t).FStar_Syntax_Syntax.pos in
            let args =
              let uu____21155 = FStar_Syntax_Syntax.as_arg a in
              let uu____21164 =
                let uu____21175 =
                  FStar_All.pipe_right rest_bs
                    (FStar_List.map
                       (fun uu____21211 ->
                          FStar_Syntax_Syntax.as_arg
                            FStar_Syntax_Syntax.unit_const)) in
                let uu____21218 =
                  let uu____21229 = FStar_Syntax_Syntax.as_arg e in
                  [uu____21229] in
                FStar_List.append uu____21175 uu____21218 in
              uu____21155 :: uu____21164 in
            FStar_Syntax_Syntax.mk (FStar_Syntax_Syntax.Tm_app (lift, args))
              e.FStar_Syntax_Syntax.pos
let (get_field_projector_name :
  FStar_TypeChecker_Env.env ->
    FStar_Ident.lident -> Prims.int -> FStar_Ident.lident)
  =
  fun env ->
    fun datacon ->
      fun index ->
        let uu____21300 = FStar_TypeChecker_Env.lookup_datacon env datacon in
        match uu____21300 with
        | (uu____21305, t) ->
            let err n =
              let uu____21315 =
                let uu____21321 =
                  let uu____21323 = FStar_Ident.string_of_lid datacon in
                  let uu____21325 = FStar_Util.string_of_int n in
                  let uu____21327 = FStar_Util.string_of_int index in
                  FStar_Util.format3
                    "Data constructor %s does not have enough binders (has %s, tried %s)"
                    uu____21323 uu____21325 uu____21327 in
                (FStar_Errors.Fatal_UnexpectedDataConstructor, uu____21321) in
              let uu____21331 = FStar_TypeChecker_Env.get_range env in
              FStar_Errors.raise_error uu____21315 uu____21331 in
            let uu____21332 =
              let uu____21333 = FStar_Syntax_Subst.compress t in
              uu____21333.FStar_Syntax_Syntax.n in
            (match uu____21332 with
             | FStar_Syntax_Syntax.Tm_arrow (bs, uu____21337) ->
                 let bs1 =
                   FStar_All.pipe_right bs
                     (FStar_List.filter
                        (fun uu____21392 ->
                           match uu____21392 with
                           | (uu____21400, q) ->
                               (match q with
                                | FStar_Pervasives_Native.Some
                                    (FStar_Syntax_Syntax.Implicit (true)) ->
                                    false
                                | uu____21409 -> true))) in
                 if (FStar_List.length bs1) <= index
                 then err (FStar_List.length bs1)
                 else
                   (let b = FStar_List.nth bs1 index in
                    FStar_Syntax_Util.mk_field_projector_name datacon
                      (FStar_Pervasives_Native.fst b) index)
             | uu____21443 -> err Prims.int_zero)
let (get_mlift_for_subeff :
  FStar_TypeChecker_Env.env ->
    FStar_Syntax_Syntax.sub_eff -> FStar_TypeChecker_Env.mlift)
  =
  fun env ->
    fun sub ->
      let uu____21456 =
        (FStar_TypeChecker_Env.is_layered_effect env
           sub.FStar_Syntax_Syntax.source)
          ||
          (FStar_TypeChecker_Env.is_layered_effect env
             sub.FStar_Syntax_Syntax.target) in
      if uu____21456
      then
        let uu____21459 =
          let uu____21472 =
            FStar_All.pipe_right sub.FStar_Syntax_Syntax.lift_wp
              FStar_Util.must in
          lift_tf_layered_effect sub.FStar_Syntax_Syntax.target uu____21472 in
        {
          FStar_TypeChecker_Env.mlift_wp = uu____21459;
          FStar_TypeChecker_Env.mlift_term =
            (FStar_Pervasives_Native.Some
               (lift_tf_layered_effect_term env sub))
        }
      else
        (let mk_mlift_wp ts env1 c =
           let ct = FStar_Syntax_Util.comp_to_comp_typ c in
           let uu____21507 =
             FStar_TypeChecker_Env.inst_tscheme_with ts
               ct.FStar_Syntax_Syntax.comp_univs in
           match uu____21507 with
           | (uu____21516, lift_t) ->
               let wp = FStar_List.hd ct.FStar_Syntax_Syntax.effect_args in
               let uu____21535 =
                 let uu____21536 =
                   let uu___2557_21537 = ct in
                   let uu____21538 =
                     let uu____21549 =
                       let uu____21558 =
                         let uu____21559 =
                           let uu____21560 =
                             let uu____21577 =
                               let uu____21588 =
                                 FStar_Syntax_Syntax.as_arg
                                   ct.FStar_Syntax_Syntax.result_typ in
                               [uu____21588; wp] in
                             (lift_t, uu____21577) in
                           FStar_Syntax_Syntax.Tm_app uu____21560 in
                         FStar_Syntax_Syntax.mk uu____21559
                           (FStar_Pervasives_Native.fst wp).FStar_Syntax_Syntax.pos in
                       FStar_All.pipe_right uu____21558
                         FStar_Syntax_Syntax.as_arg in
                     [uu____21549] in
                   {
                     FStar_Syntax_Syntax.comp_univs =
                       (uu___2557_21537.FStar_Syntax_Syntax.comp_univs);
                     FStar_Syntax_Syntax.effect_name =
                       (sub.FStar_Syntax_Syntax.target);
                     FStar_Syntax_Syntax.result_typ =
                       (uu___2557_21537.FStar_Syntax_Syntax.result_typ);
                     FStar_Syntax_Syntax.effect_args = uu____21538;
                     FStar_Syntax_Syntax.flags =
                       (uu___2557_21537.FStar_Syntax_Syntax.flags)
                   } in
                 FStar_Syntax_Syntax.mk_Comp uu____21536 in
               (uu____21535, FStar_TypeChecker_Common.trivial_guard) in
         let mk_mlift_term ts u r e =
           let uu____21688 = FStar_TypeChecker_Env.inst_tscheme_with ts [u] in
           match uu____21688 with
           | (uu____21695, lift_t) ->
               let uu____21697 =
                 let uu____21698 =
                   let uu____21715 =
                     let uu____21726 = FStar_Syntax_Syntax.as_arg r in
                     let uu____21735 =
                       let uu____21746 =
                         FStar_Syntax_Syntax.as_arg FStar_Syntax_Syntax.tun in
                       let uu____21755 =
                         let uu____21766 = FStar_Syntax_Syntax.as_arg e in
                         [uu____21766] in
                       uu____21746 :: uu____21755 in
                     uu____21726 :: uu____21735 in
                   (lift_t, uu____21715) in
                 FStar_Syntax_Syntax.Tm_app uu____21698 in
               FStar_Syntax_Syntax.mk uu____21697 e.FStar_Syntax_Syntax.pos in
         let uu____21819 =
           let uu____21832 =
             FStar_All.pipe_right sub.FStar_Syntax_Syntax.lift_wp
               FStar_Util.must in
           FStar_All.pipe_right uu____21832 mk_mlift_wp in
         {
           FStar_TypeChecker_Env.mlift_wp = uu____21819;
           FStar_TypeChecker_Env.mlift_term =
             (match sub.FStar_Syntax_Syntax.lift with
              | FStar_Pervasives_Native.None ->
                  FStar_Pervasives_Native.Some
                    ((fun uu____21868 ->
                        fun uu____21869 -> fun e -> FStar_Util.return_all e))
              | FStar_Pervasives_Native.Some ts ->
                  FStar_Pervasives_Native.Some (mk_mlift_term ts))
         })
let (update_env_sub_eff :
  FStar_TypeChecker_Env.env ->
    FStar_Syntax_Syntax.sub_eff -> FStar_TypeChecker_Env.env)
  =
  fun env ->
    fun sub ->
      let uu____21892 = get_mlift_for_subeff env sub in
      FStar_TypeChecker_Env.update_effect_lattice env
        sub.FStar_Syntax_Syntax.source sub.FStar_Syntax_Syntax.target
        uu____21892
let (update_env_polymonadic_bind :
  FStar_TypeChecker_Env.env ->
    FStar_Ident.lident ->
      FStar_Ident.lident ->
        FStar_Ident.lident ->
          FStar_Syntax_Syntax.tscheme -> FStar_TypeChecker_Env.env)
  =
  fun env ->
    fun m ->
      fun n ->
        fun p ->
          fun ty ->
            FStar_TypeChecker_Env.add_polymonadic_bind env m n p
              (fun env1 ->
                 fun c1 ->
                   fun bv_opt ->
                     fun c2 ->
                       fun flags ->
                         fun r ->
                           mk_indexed_bind env1 m n p ty c1 bv_opt c2 flags r)