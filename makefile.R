
## Especificar fecha de datos
fecha.munis <- as.Date("2022-02-28")
fecha.edad <- fecha.munis
# fecha.edad <- as.Date("2022-02-16")


#### Descarga datos IECA ####

library(jsonlite)

## Datos diarios según fecha de diagnóstico por provincia
download.file(url = "https://www.juntadeandalucia.es/institutodeestadisticaycartografia/intranet/admin/rest/v.1.0/consulta/export/39409?type=3",
              destfile = "datos/datos_provincias_raw.csv")

## Consulta personalizable por grupos de edad, sexo y territorio
download.file(url = "https://www.juntadeandalucia.es/institutodeestadisticaycartografia/intranet/admin/rest/v1.0/consulta/40402?D_TERRITORIO_0=3143,2352,2402,2482,2713,2797,2911,3023,3142&D_SEXO_0=3691&D_EDAD_0=4306,4159,4165,4178,4184,4190,4203,4222,4234,4236,4237,4238,4239,4240,4247,4304",
              destfile = "datos/casos_edad_provs_new.json")


## Histórico de datos acumulados de COVID-19 por fecha de notificación
download.file(url = "https://www.juntadeandalucia.es/institutodeestadisticaycartografia/intranet/admin/rest/v.1.0/consulta/export/38228?type=3",
              destfile = "datos/acumulados.csv")

## Consulta personalizable de la evolución por grupos de edad y territorio de los casos confirmados PDIA según fecha de diagnóstico
download.file(url = "https://www.juntadeandalucia.es/institutodeestadisticaycartografia/intranet/admin/rest/v1.0/consulta/45380?D_TERRITORIO_0=3143&D_EDAD_0=4306,4159,4165,4178,4184,4190,4203,4222,4234,4236,4238,4239,4240,4247,4304,4237",
              destfile = "datos/confPCR_edad_fecha.json")

## Datos municipios
# download.file(url = "https://www.juntadeandalucia.es/institutodeestadisticaycartografia/intranet/admin/rest/v1.0/consulta/42798?D_TERRITORIO_0=3143,2352,503515,503516,2253,503517,2245,2250,2251,2252,2254,2255,2263,2268,2270,2292,2295,2296,2308,2312,2318,2321,2332,503518,2264,2288,2293,2315,2319,2322,2342,503519,2272,503520,2307,503521,2241,2242,2286,2291,2306,2309,2346,503522,2267,2300,2301,2327,2336,503523,2249,2266,2273,2323,2329,2331,2335,2338,503524,503525,2244,2246,2257,2271,2274,2311,2313,503526,2275,503527,2294,2316,2330,2344,503528,2278,2304,2339,2340,503529,2277,2285,2297,2299,2303,2310,2317,2325,2326,2328,2337,503530,2248,2258,2259,2261,2302,2324,2333,503531,2256,2262,2289,2290,2305,2334,2341,503532,503533,2243,503534,2247,2260,2269,2279,2287,2298,2314,9563,503535,2347,503536,2282,2284,2320,503537,2348,2343,2351,2350,2349,2402,518708,503542,2356,503545,2361,503547,2388,518709,503543,2366,2374,280346,503544,2375,503546,2386,503539,503548,2360,503549,2365,503550,2368,503551,2367,503552,2353,2396,2376,2378,503553,2380,503554,2381,503555,2384,503556,2392,503540,503557,2369,503558,2373,2398,503559,2383,503560,2385,2390,503541,503561,2354,2387,503562,2355,2358,2370,503563,2357,2371,2377,2389,2395,503564,2362,2372,2391,2393,503565,2363,2364,2379,2382,2394,2401,2400,2399,2482,503575,503579,2423,503576,503580,2404,503581,2409,2441,2477,503582,2412,2426,2450,503583,2415,2424,2448,503584,2421,2427,503585,2429,2443,503586,2439,503587,280348,2442,2459,2462,503588,2440,2446,2447,503589,2444,503590,2406,2417,2433,2457,503591,2458,503592,2460,503577,503593,2414,2416,2420,2465,2469,503594,280347,2432,503595,2419,2461,2467,503596,2449,2470,2475,503597,2403,2445,2452,2468,503598,2451,3101,503599,2407,2435,2438,2455,503578,503600,2410,2437,503601,2411,2413,2428,2431,2434,2454,2466,2473,503602,2405,2408,2425,2430,2436,2453,2456,2463,2464,2472,2474,2476,503603,2418,2422,2471,2481,2480,2479,2713,503604,503605,2486,2488,2666,503606,2500,2596,2608,2637,503607,2699,2514,2519,2528,2599,2609,2630,2670,503608,2580,2612,2629,2651,280350,2673,503609,2499,2516,2517,2524,2526,2527,2604,2636,2640,2652,2659,2665,2696,2668,2669,503610,2701,2590,2622,2662,503611,2698,2671,2672,503612,503615,2506,2523,2707,2541,2565,2683,503616,2513,2529,2530,2537,503617,2487,2533,2572,2573,2576,2702,503618,2569,2585,2635,2653,503619,2493,2501,2601,2556,2561,2584,2595,2605,503622,2484,2498,2550,2583,2704,2641,2676,503621,2508,2511,2538,2549,2554,2563,2611,2617,2643,2650,2656,503613,503623,2507,2574,2586,2598,503614,503624,2485,2521,2535,2553,503625,2494,2534,2582,2633,2678,503626,2496,2503,2518,280349,9564,2594,2663,2681,503627,2497,2504,2555,2638,503628,2505,503629,2531,2557,2581,2646,2657,503630,2483,2547,2542,2559,2700,2615,2706,2674,503631,2587,2627,2660,2677,503632,2589,503633,2512,2522,2552,9565,2570,2575,2592,2625,2626,2648,2667,503634,2520,2571,2588,2623,2634,2682,503635,2610,2708,503636,2616,503637,2495,2624,503638,2642,2654,503639,2621,2647,2709,503640,2544,2546,2532,2566,2603,2664,503641,2489,2558,2607,2632,2639,2705,2697,2703,2712,2711,2710,2797,503642,503645,2714,2720,2735,2737,2739,2746,2747,2751,2758,2761,2772,2781,2785,503646,2730,2736,280351,503647,2717,2721,2738,2756,2764,2776,503648,2733,2740,2741,2742,2744,2752,503649,2725,2731,2732,2749,2762,2765,2792,503650,2786,503643,503651,2718,503652,2726,503653,2724,2759,2778,2784,503654,2763,2768,503655,2727,2766,2774,503656,2748,2777,503657,2745,2760,2767,2769,2788,2791,503644,503658,2715,503659,2716,2719,2728,2750,2770,2771,2779,2782,2789,2790,503660,2723,503661,2734,503662,2754,503663,2755,503664,2757,2780,2787,503665,2773,2796,2795,2794,2911,503666,503670,2800,2825,2832,503671,2801,503672,2833,2860,2877,503673,2841,2856,2869,503674,2888,2899,503667,503675,2816,2817,2903,2864,503676,2813,2815,2844,503677,2834,2837,2850,2894,2900,503678,2799,2852,2858,2867,2891,503679,2826,2831,2861,2905,503680,2851,2887,503668,503681,2803,2859,2897,503682,2804,2805,2830,2840,503683,2808,2809,503684,2802,2819,2822,2876,503685,2806,2838,2849,2855,2885,2895,503686,2824,2828,2862,2863,2879,2884,503669,503687,2807,2812,2846,2857,503688,2907,2810,503689,2827,2829,2847,2880,503690,2904,2853,2854,503691,2814,2836,2843,2865,2871,2872,2881,2882,2892,2902,503692,2845,2866,2873,503693,2842,2870,503694,2906,503695,2875,2889,503696,2818,2874,2893,503697,2896,503698,2848,2898,2910,2909,2908,3023,503699,503705,2926,3005,3017,3008,503706,2928,2958,2960,3007,3010,3009,503707,2921,2943,2946,3000,3001,503708,2912,2966,2970,2983,503700,503709,2916,2927,2945,2956,2998,503710,2920,2937,2938,2941,2955,2961,2973,503711,2914,2915,2950,2954,2995,503712,2964,2986,503713,3003,503714,2930,3006,503715,2913,2944,2990,2997,2999,3011,503701,503716,2918,503717,2919,503718,2923,2929,2947,503719,2924,2951,3002,3012,503720,2949,2991,503721,2953,2969,2984,503702,503722,2952,2962,2979,503723,2965,2981,503724,2934,2972,2980,2987,503725,2936,3016,503703,503726,2922,2978,3004,503727,2977,2982,2993,503704,503728,2917,2932,2933,2935,2940,2967,2968,2975,503729,2939,2957,2974,2985,503730,2925,2931,2942,2948,2959,2963,2971,2976,3018,2988,2992,2996,3019,3022,3021,3020,3142,503731,503736,3027,503737,3063,503738,3036,3098,503739,3045,503740,3138,3080,503741,3096,503742,3060,3091,503743,3092,3103,503744,3061,3090,280352,3124,503732,503745,3046,3053,3118,3125,503746,3054,3072,503748,3034,3059,3136,3107,503749,3086,3097,503750,3026,3094,3114,3128,503751,3037,3050,2743,2753,3077,3102,3127,503752,3069,3115,503753,3038,3040,3041,3055,3065,3116,3123,503754,3042,3122,503733,503755,3064,503756,3032,3062,3089,3119,3130,503757,3039,3051,3066,3071,3075,3081,3088,3099,3111,503758,3133,3067,3083,503759,3087,503760,3024,3079,3095,3113,503761,3104,503734,503762,3029,3044,3052,503763,3043,3131,503764,3048,3121,3129,503765,3049,503766,3025,3057,3073,503767,3058,3093,3100,3117,503768,3033,3056,3068,3070,3074,3084,3109,3112,503769,3031,503770,3110,503771,3030,3047,3082,3105,503772,3085,3132,503773,2722,2729,2783,2793,503735,503774,3120,3141,3140,3139",
#               destfile = "datos/municipios.dia/Municipios_todos_datoshoy.json")
download.file(url = "https://tinyurl.com/IECAmunis",
              destfile = "datos/municipios.dia/Municipios_todos_datoshoy.json")

### Pirámides de edad

## Casos confirmados
download.file(url = "https://www.juntadeandalucia.es/institutodeestadisticaycartografia/intranet/admin/rest/v.1.0/consulta/export/39356?type=3",
              destfile = "datos/edad.sexo/datos_casos_edad_sexo.csv")

## Hospitalizados
download.file(url = "https://www.juntadeandalucia.es/institutodeestadisticaycartografia/intranet/admin/rest/v.1.0/consulta/export/39351?type=3",
              destfile = "datos/edad.sexo/datos_hosp_edad_sexo.csv")

## UCI
download.file(url = "https://www.juntadeandalucia.es/institutodeestadisticaycartografia/intranet/admin/rest/v.1.0/consulta/export/39355?type=3",
              destfile = "datos/edad.sexo/datos_uci_edad_sexo.csv")

## Defunciones
download.file(url = "https://www.juntadeandalucia.es/institutodeestadisticaycartografia/intranet/admin/rest/v.1.0/consulta/export/39354?type=3",
              destfile = "datos/edad.sexo/datos_def_edad_sexo.csv")


### Vacunas

## Evolución de la cobertura vacunal con pauta completa por grupos de edad
download.file(url = "https://www.juntadeandalucia.es/institutodeestadisticaycartografia/intranet/admin/rest/v.1.0/consulta/export/54862?type=3",
              destfile = "datos/vacu_edades.csv")

## Evolución de la cobertura vacunal con pauta completa por grupos de edad
download.file(url = "https://www.juntadeandalucia.es/institutodeestadisticaycartografia/intranet/admin/rest/v.1.0/consulta/export/53911?type=3",
              destfile = "datos/municipios.dia/vacu_muni.csv")



###############################


library(dplyr)

#### Datos municipios #####

muni.data <- readr::read_csv("datos/municipios.csv",
                             col_types = "Dcccddddd",
                             guess_max = 50000)

munis <- readr::read_csv("datos/muni_prov_dist.csv")


if (!fecha.munis %in% as.Date(muni.data$Fecha)) {

  ## Using big CSV from https://www.juntadeandalucia.es/institutodeestadisticaycartografia/badea/operaciones/consulta/anual/42798?CodOper=b3_2314&codConsulta=42798
  muni.dia <- readr::read_csv2("datos/municipios.dia/Municipios_todos_datoshoy.csv", col_types = "ccd_")

  ## Using CSV by province
  # munis.dia <- list.files("datos/municipios.dia/", pattern = ".csv", full.names = TRUE)
  # muni.dia <- purrr::map_df(munis.dia, readr::read_csv2, col_types = "ccd_")

  muni.dia <- muni.dia %>%
    rename(Municipio = `Lugar de residencia`) %>%
    #dplyr::select(-X4) %>%
    dplyr::filter(!is.na(Municipio), Municipio %in% unique(muni.data$Municipio)) %>%
    dplyr::filter(!is.na(Medida)) %>%
    dplyr::filter(Medida != "Población media anual") %>%
    dplyr::filter(Medida != "Tasa PDIA") %>%
    dplyr::filter(Medida != "Confirmados PDIA 7 días") %>%
    dplyr::filter(Medida != "Tasa PDIA 7 dias") %>%
    dplyr::filter(Medida != "Tasa total confirmados") %>%
    dplyr::filter(Medida != "Curados") %>%
    mutate(Medida = ifelse(Medida == "Tasa PDIA 14 dias", "Tasa PDIA 14 días", Medida)) %>%
    assertr::verify(unique(.$Medida) ==
                      c("Confirmados PDIA",
                        "Confirmados PDIA 14 días",
                        "Tasa PDIA 14 días",
                        "Total Confirmados",
                        "Fallecidos")) %>%
    mutate(Medida = ifelse(Medida == "Tasa PDIA 14 días", "Conf14d_100.000hab", Medida)) %>%
    mutate(Medida = ifelse(Medida == "Confirmados PDIA", "Confirmados.PCR.TA", Medida)) %>%
    mutate(Medida = ifelse(Medida == "Confirmados PDIA 14 días", "Confirmados.PCR.TA.14d", Medida)) %>%
    mutate(Medida = ifelse(Medida == "Total Confirmados", "ConfirmadosTotal", Medida)) %>%
    mutate(Medida = ifelse(Medida == "Fallecidos", "Defunciones", Medida)) %>%
    dplyr::filter(Medida == "Confirmados.PCR.TA" | Medida == "Confirmados.PCR.TA.14d" |
                    Medida == "Conf14d_100.000hab" |
                    Medida == "ConfirmadosTotal" | Medida == "Defunciones") %>%
    mutate(rownumber = 1:nrow(.)) %>%
    group_by(Municipio) %>%
    arrange(rownumber) %>%
    slice_tail(n = 5) %>%
    ungroup() %>%
    select(-rownumber) %>%
    tidyr::pivot_wider(names_from = "Medida", values_from = "Valor") %>%
    mutate(Fecha = fecha.munis) %>%
    right_join(munis, by = "Municipio") %>%
    dplyr::select(Fecha, Provincia, Distrito, Municipio,
                  Confirmados.PCR.TA, Confirmados.PCR.TA.14d, Conf14d_100.000hab,
                  ConfirmadosTotal, Defunciones)

  muni.dia %>%
    assertr::verify(all.equal(names(muni.dia), names(muni.data)))

  muni.data <- dplyr::bind_rows(muni.data, muni.dia) %>%
    arrange(Fecha, Provincia, Distrito, Municipio) %>%
    readr::write_csv(file = "datos/municipios.csv")

}




#### Casos, Ingresados, Defunciones, etc por edad

datos.edad.sexo <- readr::read_csv("datos/datos_edad_sexo.csv")

if (!fecha.edad %in% as.Date(datos.edad.sexo$Fecha)) {

casos.dia <- readr::read_csv2("datos/edad.sexo/datos_casos_edad_sexo.csv",
                              col_types = "cccd_") %>%
  filter(Medida != "% pirámide") %>%
  rename(Confirmados = Valor) %>%
  select(-Medida) %>%
  mutate(Fecha = fecha.edad) %>%
  relocate(Fecha)

hosp.dia <- readr::read_csv2("datos/edad.sexo/datos_hosp_edad_sexo.csv",
                              col_types = "cccd_") %>%
  filter(Medida != "% pirámide") %>%
  rename(Hospitalizados = Valor) %>%
  select(-Medida) %>%
  mutate(Fecha = fecha.edad) %>%
  relocate(Fecha)

uci.dia <- readr::read_csv2("datos/edad.sexo/datos_uci_edad_sexo.csv",
                             col_types = "cccd_") %>%
  filter(Medida != "% pirámide") %>%
  rename(UCI = Valor) %>%
  select(-Medida) %>%
  mutate(Fecha = fecha.edad) %>%
  relocate(Fecha)

def.dia <- readr::read_csv2("datos/edad.sexo/datos_def_edad_sexo.csv",
                             col_types = "cccd_") %>%
  filter(Medida != "% pirámide") %>%
  rename(Defunciones = Valor) %>%
  select(-Medida) %>%
  mutate(Fecha = fecha.edad) %>%
  relocate(Fecha)

datos.edad.sexo.dia <- casos.dia %>%
  left_join(hosp.dia, by = c("Fecha", "Edad", "Sexo")) %>%
  left_join(uci.dia, by = c("Fecha", "Edad", "Sexo")) %>%
  left_join(def.dia, by = c("Fecha", "Edad", "Sexo"))

datos.edad.sexo.dia %>%
  assertr::verify(all.equal(names(datos.edad.sexo.dia), names(datos.edad.sexo)))

datos.edad.sexo <- dplyr::bind_rows(datos.edad.sexo, datos.edad.sexo.dia) %>%
  arrange(Fecha, Edad, Sexo) %>%
  readr::write_csv(file = "datos/datos_edad_sexo.csv")

}


#### Descargar datos CNE ####

options(timeout = max(1000, getOption("timeout")))

url.iscii.edad <- "https://cnecovid.isciii.es/covid19/resources/casos_hosp_uci_def_sexo_edad_provres.csv"
if (!httr::http_error(url.iscii.edad)) {
  download.file("https://cnecovid.isciii.es/covid19/resources/casos_hosp_uci_def_sexo_edad_provres.csv",
              destfile = "datos/casos_hosp_uci_def_sexo_edad_provres.csv")
}



#### Descarga datos Ocupación Hospitalaria Minist. Sanidad
fecha.informe <- Sys.Date()
url.camas.minist <- paste0("https://www.mscbs.gob.es/profesionales/saludPublica/ccayes/alertasActual/nCov/documentos/Datos_Capacidad_Asistencial_Historico_",
                           format(fecha.informe, "%d%m%Y"), ".csv")
while (httr::http_error(url.camas.minist)) {
  fecha.informe <- fecha.informe - 1
  url.camas.minist <- paste0("https://www.mscbs.gob.es/profesionales/saludPublica/ccayes/alertasActual/nCov/documentos/Datos_Capacidad_Asistencial_Historico_",
                             format(fecha.informe, "%d%m%Y"), ".csv")
}
download.file(url.camas.minist, destfile = "datos/datos_camas_ministerio.csv")



#### Datos Minist Nº pruebas

fecha.test <- Sys.Date()
url.test.minist <- paste0("https://www.mscbs.gob.es/profesionales/saludPublica/ccayes/alertasActual/nCov/documentos/Datos_Pruebas_Realizadas_Historico_",
                           format(fecha.test, "%d%m%Y"), ".csv")
while (httr::http_error(url.test.minist)) {
  fecha.test <- fecha.test - 1
  url.test.minist <- paste0("https://www.mscbs.gob.es/profesionales/saludPublica/ccayes/alertasActual/nCov/documentos/Datos_Pruebas_Realizadas_Historico_",
                             format(fecha.test, "%d%m%Y"), ".csv")
}
download.file(url.test.minist, destfile = "datos/datos_test_ministerio.csv")



#### Datos movilidad Google ####

if (difftime(Sys.Date(), as.Date(file.mtime("datos/Region_Mobility_Report_CSVs.zip")), units = "days") > 7) {
  download.file("https://www.gstatic.com/covid19/mobility/Region_Mobility_Report_CSVs.zip",
                destfile = "datos/Region_Mobility_Report_CSVs.zip")
  file.remove("datos/2021_ES_Region_Mobility_Report.csv")
}




## Render

rmarkdown::render("evolucion-coronavirus-andalucia.Rmd")


