module TailRec
export @tailrec

macro tailrec(func)
    fargs=map(e->isa(e,Expr) ? e.args[1] : e,func.args[1].args)
    fbody=func.args[2]
    fbody=rewrite(fbody,fargs)
    func.args[2]=Expr(:block,:(@label retry),fbody)
    esc(func)
end

function rewrite(expr,args,callflag=false)
    if !isa(expr,Expr)
        expr
    elseif expr.head == :call && expr.args[1] == args[1]
        if callflag
            @warn("Not tail recursive.")
            expr
        else
            newargs=Expr(:tuple)
            newargs.args=args[2:end]
            oldargs=Expr(:tuple)
            oldargs.args=expr.args[2:end]
            Expr(:block, Expr(:(=),newargs,oldargs), :(@goto retry) )
        end
    elseif expr.head == :block
        expr.args[end]=rewrite(expr.args[end],args,expr.head==:call ? true : callflag)
        expr
    else
        expr.args = map(a->rewrite(a,args,expr.head==:call ? true : callflag), expr.args)
        expr
    end
end
end
