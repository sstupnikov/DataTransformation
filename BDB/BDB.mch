/* BDB
 * Author: ssa
 * Creation date: 4/1/2025
 */
MACHINE
    BDB

SEES 
  StringType  

DEFINITIONS
    bdb3_models_catline_struct == struct(
        cat_id: INT, // 'id' from BDB
        obj_id: seq(CHAR)
    );
    
    bdb3_models_bdbsystem_struct == struct(
        catline_id: INT
    );
    
    bdb3_models_bdbcomp_struct == struct(
        catline_id: INT,
        mag: REAL,
        spBand: seq(CHAR), // 'band' from BDB
        spType: seq(CHAR),
        KK: REAL, // 'K' from BDB
        V0: REAL,
        plx: REAL,
        pmRA: REAL,
        pmDE: REAL,
        crdRA: REAL,
        crdDE: REAL,
        sys_catline_id: INT,
        FWHM: REAL, 
        FEW: REAL,
        Mass: REAL,
        LL: REAL, // 'L' from BDB
        Teff: REAL,
        gg: REAL, // 'g' from BDB
        Radius: REAL,
        MM: REAL // 'M' from BDB
    );
    
    bdb3_models_bdbpair_struct == struct(
        catline_id: INT,
        Epoch: INT,
        Theta: REAL,
        Rho: REAL,
        PP: REAL, // 'P' from BDB
        aa: REAL, // 'a' from BDB
        ii: REAL, // 'i' from BDB
        ee: REAL, // 'e' from BDB
        V0: REAL,
        plx: REAL,
        pmRA: REAL,
        pmDE: REAL,
        crdRA: REAL,
        crdDE: REAL,
        mmax: REAL,
        mmin: REAL,
        spBand: seq(CHAR),
        OType: seq(CHAR),
        EType: seq(CHAR),
        sys_catline_id: INT,
        compA_catline_id: INT,
        compB_catline_id: INT,
        jmag: REAL,
        mdif: REAL,
        qq: REAL, // 'q' from BDB
        Mf: REAL,
        sumM: REAL,
        jL: REAL,
        jTeff: REAL
    )
    

ABSTRACT_VARIABLES
    
    bdb3_models_catline,
    bdb3_models_bdbsystem,
    bdb3_models_bdbcomp,
    bdb3_models_bdbpair    

INVARIANT
    
    bdb3_models_catline: FIN(bdb3_models_catline_struct) &
    !(catline1, catline2).(catline1: bdb3_models_catline & catline2: bdb3_models_catline & 
        catline1'cat_id = catline2'cat_id => 
        catline1 = catline2) &
    
    bdb3_models_bdbsystem: FIN(bdb3_models_bdbsystem_struct) &
    !(system1, system2).(system1: bdb3_models_bdbsystem & system2: bdb3_models_bdbsystem & 
        system1'catline_id = system2'catline_id => 
        system1 = system2) &
    !system.(system: bdb3_models_bdbsystem => 
        #catline.(catline: bdb3_models_catline & catline'cat_id = system'catline_id) ) &
        
    bdb3_models_bdbcomp: FIN(bdb3_models_bdbcomp_struct) &
    !(comp1, comp2).(comp1: bdb3_models_bdbcomp & comp2: bdb3_models_bdbcomp & 
        comp1'catline_id = comp2'catline_id => 
        comp1 = comp2) &
    !comp.(comp: bdb3_models_bdbcomp => 
        #catline.(catline: bdb3_models_catline & catline'cat_id = comp'catline_id) ) &
    !comp.(comp: bdb3_models_bdbcomp => 
        #system.(system: bdb3_models_bdbsystem & system'catline_id = comp'sys_catline_id) ) &
    
    bdb3_models_bdbpair: FIN(bdb3_models_bdbpair_struct) &
    !(pair1, pair2).(pair1: bdb3_models_bdbpair & pair2: bdb3_models_bdbpair & 
        pair1'catline_id = pair2'catline_id => 
        pair1 = pair2) &
    !pair.(pair: bdb3_models_bdbpair => 
        #catline.(catline: bdb3_models_catline & catline'cat_id = pair'catline_id) ) & 
    !pair.(pair: bdb3_models_bdbpair => 
        #comp.(comp: bdb3_models_bdbcomp & comp'catline_id = pair'compA_catline_id) )  &
    !pair.(pair: bdb3_models_bdbpair => 
        #comp.(comp: bdb3_models_bdbcomp & comp'catline_id = pair'compB_catline_id) ) & 
    !pair.(pair: bdb3_models_bdbpair => 
        #system.(system: bdb3_models_bdbsystem & system'catline_id = pair'sys_catline_id) ) 

INITIALISATION
    bdb3_models_catline:= {}
    ||
    bdb3_models_bdbsystem:= {}
    ||
    bdb3_models_bdbcomp:= {}
    ||
    bdb3_models_bdbpair:= {}

OPERATIONS
    
res <-- insert_catline(anobj_id) =
PRE anobj_id: seq(CHAR)
THEN
    ANY acat_id WHERE
        acat_id: INT & 
        not(#catline.(catline: bdb3_models_catline & catline'cat_id = acat_id))
    THEN
        bdb3_models_catline:= bdb3_models_catline \/ 
            {rec(cat_id: acat_id, obj_id: anobj_id)}
        ||
        res:= acat_id
    END
END;    

insert_system(acatline_id) =
PRE acatline_id: INT
THEN     
    SELECT 
        not(#system.(system: bdb3_models_bdbsystem & system'catline_id = acatline_id)) &
        #catline.(catline: bdb3_models_catline & catline'cat_id = acatline_id)
    THEN
        bdb3_models_bdbsystem:= bdb3_models_bdbsystem \/ {rec(catline_id: acatline_id)}
    END    
END;

insert_comp(acatline_id, amag, aspBand, aspType, aKK, aV0, aplx, apmRA, apmDE, acrdRA, acrdDE, asys_catline_id, aFWHM, aFEW,    aMass, aLL, aTeff, agg, aRadius, aMM) = 
PRE
    acatline_id: INT & amag: REAL & aspBand: seq(CHAR) & aspType: seq(CHAR) & aKK: REAL & aV0: REAL & aplx: REAL & apmRA: REAL  & apmDE: REAL & acrdRA: REAL & acrdDE: REAL & asys_catline_id: INT & aFWHM: REAL & aFEW: REAL & aMass: REAL & aLL: REAL &      aTeff: REAL & agg: REAL & aRadius: REAL & aMM: REAL
THEN
    SELECT 
        not(#comp.(comp: bdb3_models_bdbcomp & comp'catline_id = acatline_id)) &
        #catline.(catline: bdb3_models_catline & catline'cat_id = acatline_id) &
        #system.(system: bdb3_models_bdbsystem & system'catline_id = asys_catline_id)
    THEN
        bdb3_models_bdbcomp:= bdb3_models_bdbcomp \/ 
        {rec(catline_id: acatline_id, mag: amag, spBand: aspBand, spType: aspType, KK: aKK, V0: aV0, plx: aplx, pmRA: apmRA, pmDE: apmDE, crdRA: acrdRA, crdDE: acrdDE, sys_catline_id: asys_catline_id, FWHM: aFWHM, FEW: aFEW, Mass: aMass, LL: aLL, Teff: aTeff, gg: agg, Radius: aRadius, MM: aMM)}
    END    
END;

insert_pair(acatline_id, aEpoch, aTheta, aRho, aPP, anaa, aii, aee, aV0, aplx, apmRA, apmDE, acrdRA, acrdDE, ammax, ammin, aspBand, aOType, aEType, asys_catline_id, acompA_catline_id, acompB_catline_id, ajmag, amdif, aqq, aMf, asumM, ajL, ajTeff) =
PRE 
    acatline_id: INT & aEpoch: INT & aTheta: REAL & aRho: REAL & aPP: REAL & anaa: REAL & aii: REAL & aee: REAL & aV0: REAL & aplx: REAL & apmRA: REAL & apmDE: REAL & acrdRA: REAL & acrdDE: REAL & ammax: REAL & ammin: REAL & aspBand: seq(CHAR) &       aOType: seq(CHAR) & aEType: seq(CHAR) & asys_catline_id: INT & acompA_catline_id: INT & acompB_catline_id: INT & ajmag: REAL &        amdif: REAL & aqq: REAL & aMf: REAL & asumM: REAL & ajL: REAL & ajTeff: REAL
THEN
    SELECT 
        not(#pair.(pair: bdb3_models_bdbpair & pair'catline_id = acatline_id)) &
        #catline.(catline: bdb3_models_catline & catline'cat_id = acatline_id) &
        #system.(system: bdb3_models_bdbsystem & system'catline_id = asys_catline_id) &
        #comp.(comp: bdb3_models_bdbcomp & comp'catline_id = acompA_catline_id) & 
        #comp.(comp: bdb3_models_bdbcomp & comp'catline_id = acompB_catline_id)
    THEN
        bdb3_models_bdbpair:= bdb3_models_bdbpair \/ 
        {rec(catline_id: acatline_id, Epoch: aEpoch, Theta: aTheta, Rho: aRho, PP: aPP, aa: anaa, ii: aii, ee: aee, V0: aV0, plx: aplx, pmRA: apmRA, pmDE: apmDE, crdRA: acrdRA, crdDE: acrdDE, mmax: ammax, mmin: ammin, spBand: aspBand, OType: aOType, EType: aEType, sys_catline_id: asys_catline_id, compA_catline_id: acompA_catline_id, compB_catline_id: acompB_catline_id, jmag: ajmag, mdif: amdif, qq: aqq, Mf: aMf, sumM: asumM, jL: ajL, jTeff: ajTeff)}
    END    
END    

END
