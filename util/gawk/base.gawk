@include "global.gawk"


function unlock_deletion(){
    if(remote_empty[side_both]){
        deletion_blocked_by = "Deletion blocked as all sides need to be restored"
        return;
    }
    if(remote_empty[side_a]){
        deletion_blocked_by = "Deletion blocked as side A needs to be restored"
        return;
    }
    if(remote_empty[side_b]){
        deletion_blocked_by = "Deletion blocked as side B needs to be restored"
        return;
    }
    
    deletion_allowed = 1;
}
function generate_missing_refs(    ref){
    for(ref in refs){
        if(!refs[ref][side_a][remote][ref_key]){
            refs[ref][side_a][remote][ref_key] = remote_refs_prefix ref;
        }
        if(!refs[ref][side_b][remote][ref_key]){
            refs[ref][side_b][remote][ref_key] = remote_refs_prefix ref;
        }
        if(!refs[ref][side_a][track][ref_key]){
            refs[ref][side_a][track][ref_key] = track_refs_prefix origin[side_a] "/" ref;
        }
        if(!refs[ref][side_b][track][ref_key]){
            refs[ref][side_b][track][ref_key] = track_refs_prefix origin[side_b] "/" ref;
        }

        # d_trace("ref is " ref);
        # d_trace("track ref_key side_a " refs[ref][side_a][track][ref_key]);
        # d_trace("track ref_key side_b " refs[ref][side_b][track][ref_key]);
        # d_trace("remote ref_key side_a " refs[ref][side_a][remote][ref_key]);
        # d_trace("remote ref_key side_b " refs[ref][side_b][remote][ref_key]);
    }
}

function append_by_side(side, host, addition){
    host[side] = host[side] (host[side] ? newline_substitution : "") addition;
}
function append_by_val(host, addition){
    host[val] = host[val] (host[val] ? newline_substitution : "") addition;
}

function use_victim_sync(ref){
    if(explicit_victim_ref(ref))
        return 1;

    if(use_conv_sync(ref)){
        # sync_enabling_branch may be a conventional branch.
        return 0;
    }

    # by default sync_enabling_branch uses the victim syncing strategy.
    return ref == sync_enabling_branch;
}

function use_conv_sync(ref) {
    return side_a_conv_ref(ref) || side_b_conv_ref(ref);
}

function side_conv_ref(ref, side,    conv_pref){
    conv_pref = prefix[side];
    if(!conv_pref){
        return 0;
    }

    return index(ref, conv_pref) == 1;
}

function side_a_conv_ref(ref){
    return side_conv_ref(ref, side_a);
}

function side_b_conv_ref(ref){
    return side_conv_ref(ref, side_b);
}

function explicit_victim_ref(ref){
    if(!pref_victim){
        return 0;
    }

    return index(ref, pref_victim) == 1;
}
