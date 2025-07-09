import Pkg
Pkg.activate("ftp_project")

include("objects.jl")
include("utilities.jl")
include("model.jl")


instance = load_ftp_instance("ftp.json")
println("Loaded instance:\n\n $(instance)")


model = create_model(instance)


optimize!(model)

solution = extract_solution(model, instance)
println("$(solution)")
