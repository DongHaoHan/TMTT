function [error] = Relative_error(Hx_pre, Hx_Ref)
    Hx_pre = abs(Hx_pre);
    Hx_Ref = abs(Hx_Ref);

    Hx_pre = Hx_pre(:);
    Hx_Ref = Hx_Ref(:);

    diff_sq = (Hx_pre - Hx_Ref) .* (Hx_pre - Hx_Ref);
    numerator = sqrt(sum(diff_sq));

    ref_sq = Hx_Ref .* Hx_Ref;
    denominator = sqrt(sum(ref_sq));

    error = numerator / denominator;
end