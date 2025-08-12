import Pkg
Pkg.activate("unified_project/")

abstract type NetworkDesignProblem end
struct McndProblem <: NetworkDesignProblem end
struct FtpProblem <: NetworkDesignProblem end


include("objects.jl")
include("utilities.jl")
include("model.jl")

function model_optimization(problem, instance_name)
    instance = load_instance(instance_name, problem)
    model = create_model(instance)

    optimize!(model)
    solution = extract_solution(model, instance)
    println("$(solution)")



end


model_optimization(McndProblem(), "instances/mcnd_ex.json")