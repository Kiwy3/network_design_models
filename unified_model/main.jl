import Pkg
Pkg.activate("unified_project/")

abstract type NetworkDesignProblem end
struct McndProblem <: NetworkDesignProblem end
struct FtpProblem <: NetworkDesignProblem end


include("objects.jl")
include("utilities.jl")
include("model.jl")



problem = McndProblem()
instance = load_instance("instances/mcnd_c33.json", problem)

problem = FtpProblem()
instance = load_instance("instances/ftp.json", problem)

println("Loaded instance:\n\n $(instance)")



model = create_model(instance)


optimize!(model)

solution = extract_solution(model, instance)
println("$(solution)")
