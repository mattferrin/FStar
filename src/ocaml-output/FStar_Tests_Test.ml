open Prims
let main : 'Auu____79288 'Auu____79289 . 'Auu____79288 -> 'Auu____79289 =
  fun argv  ->
    FStar_Util.print_string "Initializing ...\n";
    (try
       (fun uu___745_79301  ->
          match () with
          | () ->
              ((let uu____79303 = FStar_Tests_Pars.init ()  in
                FStar_All.pipe_right uu____79303 (fun a1  -> ()));
               FStar_Tests_Norm.run_all ();
               (let uu____79306 = FStar_Tests_Unif.run_all ()  in
                if uu____79306
                then ()
                else FStar_All.exit (Prims.parse_int "1"));
               FStar_All.exit (Prims.parse_int "0"))) ()
     with
     | FStar_Errors.Error (err,msg,r) when
         let uu____79324 = FStar_Options.trace_error ()  in
         FStar_All.pipe_left Prims.op_Negation uu____79324 ->
         (if r = FStar_Range.dummyRange
          then FStar_Util.print_string msg
          else
            (let uu____79332 = FStar_Range.string_of_range r  in
             FStar_Util.print2 "%s: %s\n" uu____79332 msg);
          FStar_All.exit (Prims.parse_int "1")))
  