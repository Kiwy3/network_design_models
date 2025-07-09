
using JuMP
using HiGHS

function create_model(instance::Network)
    model = Model(HiGHS.Optimizer)

    # Define variables
    @variable(model, y[instance.arcs ], Bin)  # Flow on arcs
    @variable(model, x[instance.arcs] >= 0)  # Flow on arcs

    # Objective: Minimize total cost
    @objective(model, Min, sum(arc.variable_cost * x[arc] + arc.fixed_cost * y[arc] for arc in instance.arcs))

    # Constraints

    for (i,node) in instance.nodes
        @constraint(model, sum(x[arc] for arc in instance.arcs if arc.origin == node) == node.stock)
        @constraint(model, sum(x[arc] for arc in instance.arcs if arc.destination == node) == node.demand)
    end

    for arc in instance.arcs
        @constraint(model, x[arc] <= y[arc] * min(arc.origin.stock, arc.destination.demand) )  # Big-M constraint to link y and x
    end

    return model
end

function extract_solution(model::Model, instance::Network)::FTPSolution
    x_values = value.(model[:x])
    y_values = value.(model[:y])

    objective_value = JuMP.objective_value(model)
    solution = FTPSolution(instance, objective_value, x_values, y_values)

    return solution
end
