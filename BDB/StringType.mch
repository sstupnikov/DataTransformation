/* StringType
 * Author: ssa
 * Creation date: 3/28/2025
 */
MACHINE
    StringType

SETS 
    CHAR = { CHAR_A, CHAR_a, CHAR_B, CHAR_b, CHAR_C, CHAR_c, CHAR_D, CHAR_d, CHAR_E, CHAR_e, CHAR_F, CHAR_f, CHAR_G, CHAR_g, CHAR_H, CHAR_h, CHAR_I, CHAR_i, CHAR_J, CHAR_j, CHAR_K, CHAR_k, CHAR_L, CHAR_l, CHAR_M, CHAR_m, CHAR_N, CHAR_n, CHAR_O, CHAR_o, CHAR_P, CHAR_p, CHAR_Q, CHAR_q, CHAR_R, CHAR_r, CHAR_S, CHAR_s, CHAR_T, CHAR_t, CHAR_U, CHAR_u, CHAR_V, CHAR_v, CHAR_W, CHAR_w, CHAR_X, CHAR_x, CHAR_Y, CHAR_y, CHAR_Z, CHAR_z, 
        CHAR_0, CHAR_1, CHAR_2, CHAR_3, CHAR_4, CHAR_5, CHAR_6, CHAR_7, CHAR_8, CHAR_9, 
        CHAR_DOT, CHAR_COMMA, CHAR_PLUS, CHAR_MINUS, CHAR_SPACE, CHAR_LBRACE, CHAR_RBRACE, CHAR_COLON, CHAR_SLASH, CHAR_QESTION }

/*
ABSTRACT_CONSTANTS
    is_substring_of

*/

/*
    remove_lead_spaces,
    remove_trail_spaces,
    strip,
    find
*/

/*
PROPERTIES   
    is_substring_of: seq(CHAR)*seq(CHAR) +-> BOOL &
    !(str1, str2).(str1: seq(CHAR) & str2: seq(CHAR) & size(str1) <= 10 & size(str2) <= 10 =>  
        ( #(ahead, atail).(ahead: seq(CHAR) & size(ahead) <= 10 & 
                atail: seq(CHAR) & size(atail) <= 10 & 
                ahead^str1^atail = str2) => 
            is_substring_of(str1, str2) = TRUE) &
        (not(#(ahead, atail).(ahead: seq(CHAR) & size(ahead) <= 10 & 
                atail: seq(CHAR) & size(atail) <= 10 & 
                ahead^str1^atail = str2) => 
            is_substring_of(str1, str2) = FALSE) ) 
    )
*/ 

/*
    remove_lead_spaces: (INT +-> CHAR) +-> (INT +-> CHAR) &
    remove_lead_spaces({}) = {} &
    !str.(str: INT +-> CHAR & card(str) > 0 & 0: dom(str) & str(0) /= CHAR_SPACE => 
        remove_lead_spaces(str) = str) &
    // 'ls' is the last index value of the leading space sequence 
    !(str, ls).(str: INT +-> CHAR & card(str) > 0 & 
        !mm.(mm: INT & mm >= 0 & mm <= card(str) => mm: dom(str)) &        
        str(0) = CHAR_SPACE &
        ls: INT & ( (ls + 1): dom(str) => str(ls + 1) /= CHAR_SPACE) &
        !ii.(ii: INT & ii >= 0 & ii <= ls => str(ii) = CHAR_SPACE)
        => 
        remove_lead_spaces(str) = { ind, val | 
            ind: INT & ind >= 0 & ind <= card(str) - ls - 2 & 
            val: CHAR & val = str(ls + 1) } ) &
    
    
    remove_trail_spaces: (INT +-> CHAR) +-> (INT +-> CHAR) &    
    remove_trail_spaces({}) = {} &
    !str.(str: INT +-> CHAR & card(str) > 0 & (card(str)-1): dom(str) & str(card(str)-1) /= CHAR_SPACE => 
        remove_trail_spaces(str) = str) &
    // 'fs' is the first index value of the trailing space sequence 
    !(str, fs).(str: INT +-> CHAR & card(str) > 0 & 
        !mm.(mm: INT & mm >= 0 & mm <= card(str) => mm: dom(str)) &        
        str(card(str) - 1) = CHAR_SPACE &
        fs: INT & ( (fs - 1): dom(str) => str(fs - 1) /= CHAR_SPACE) &
        !ii.(ii: INT & ii >= fs & ii <= (card(str) - 1) => str(ii) = CHAR_SPACE)
        => 
        remove_trail_spaces(str) = { ind, val | 
            ind: INT & ind >= 0 & ind <= fs - 1 & 
            val: CHAR & val = str(fs) } ) &

    // remove leading and trailing spaces
    strip: (INT +-> CHAR) +-> (INT +-> CHAR) & 
    !ss.(ss: INT +-> CHAR => strip(ss) = remove_trail_spaces(remove_lead_spaces(ss))) &
    
    // Returns first index pairing a character in a string.
    // If the character is not contained in the string returns -1. 
    find : (INT +-> CHAR) * CHAR --> INT &
    !(str, char).(str: INT +-> CHAR & char: CHAR & char /: ran(str) => find(str, char) = -1) &
    !(str, char, ind).(str: INT +-> CHAR & char: CHAR & char: ran(str) & ind: INT &
        str(ind) = char & not(#ind1.(ind1: INT & ind1 < ind & str(ind1) = char))
        => find(str, char) = ind)
*/    

OPERATIONS 

// return first index value ind such that str(ind) = char
// if char /: ran(str) then return -1
res <-- find(str, char) =
PRE str: seq(CHAR) & char: CHAR
THEN
    IF char /: ran(str) THEN 
        res:= -1 
    ELSE  
        ANY ind WHERE
            ind: INT & ind >= 1 & ind <= size(str) & str(ind) = char &
            not(#ind1.(ind1: INT & ind1: dom(str) & ind >= 1 & ind1 < ind & str(ind1) = char))
        THEN
            res:= ind
        END
    END
END;

res <-- is_string_of_spaces(str) =
PRE str: seq(CHAR)
THEN
    IF !char.(char: CHAR & char: ran(str) => char = CHAR_SPACE)
    THEN
        res:= TRUE
    ELSE
        res:= FALSE
    END
END;    

// remove head and trail spaces
res <-- strip(str) =
PRE str: seq(CHAR) & res: seq(CHAR) & str: FIN(str)
THEN
    // empty string
    IF str = [] THEN 
        res:= []
    // no lead and trail spaces    
    ELSIF (first(str) /= CHAR_SPACE) & (last(str) /= CHAR_SPACE)
    THEN
        res:= str
    // string of all spaces    
    ELSIF !ind.(ind: INT & ind >= 1 & ind <= size(str) => str(ind) = CHAR_SPACE)
    THEN    
        res:= []
    // lead spaces exist    
    ELSIF first(str) = CHAR_SPACE
    THEN
        // 'ls' is the last index value of the leading space sequence
        ANY ls WHERE
            ls: INT & ls >= 1 & ls < size(str) & str(ls + 1) /= CHAR_SPACE &
            !ind.(ind: INT & ind >= 1 & ind <= ls => str(ind) = CHAR_SPACE)
        THEN            
            // no trail spaces
            IF last(str) /= CHAR_SPACE
            THEN
                // remove head spaces
                res:= str \|/ ls
                /* { ind, val | 
                    ind: INT & ind >= 1 & ind <= card(str) - ls & 
                    val: CHAR & val = str(ls + ind) 
                } */               
            // trail spaces exist    
            ELSE 
                // 'fs' is the first index value of the trailing space sequence    
                ANY fs WHERE
                    fs: INT & fs > 1 & fs <= size(str) & str(fs - 1) /= CHAR_SPACE & ls < fs &
                    !ind.(ind: INT & ind >= fs & ind <= size(str) => str(ind) = CHAR_SPACE)
                THEN
                    // remove head and trail spaces
                    res:= (str /|\ (fs - 1)) \|/ ls
                    /* { ind, val | 
                        ind: INT & ind >= 1 & ind <= fs - ls - 1 & 
                        val: CHAR & val = str(ls + ind) 
                    } */                   
                END
            END
        END    
    // only trail spaces exist    
    ELSE    
        ANY fs WHERE
            fs: INT & fs > 1 & fs <= card(str) & str(fs - 1) /= CHAR_SPACE &
            !ind.(ind: INT & ind >= fs & ind <= size(str) => str(ind) = CHAR_SPACE)
        THEN
            // remove trail spaces
            res:=  str /|\ (fs - 1)
            /* { ind, val | 
                ind: INT & ind >= 1 & ind <= fs - 1 & 
                val: CHAR & val = str(ind) 
            } */                    
        END
    END
END;    

// split str into substrings separated by char
// char can contain in str not more than once
res <-- binary_split(str, char) =
PRE str: seq(CHAR) & char: CHAR & res: seq(seq(CHAR)) & str: FIN(str) &
    ( size(str) = 0 or 
      size(str) > 0 & card({ind | ind: INT & ind >= 1 & ind <= size(str) & str(ind) = char }) <= 1 )
THEN
    IF card({ind | ind: INT & ind >= 1 & ind <= size(str) & str(ind) = char }) = 0
    THEN
        res:= [str]
    ELSE
        ANY ind WHERE 
            ind: INT & ind >= 1 & ind <= size(str) & str(ind) = char
        THEN 
            res:= [str /|\ (ind - 1), str \|/ ind]
        END
    END 
END    

END
