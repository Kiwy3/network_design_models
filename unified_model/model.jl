
using JuMP
# using HiGHS
using Gurobi

optimizer = Gurobi.Optimizer


#ANCHOR - MCND Function
function create_model(instance::McndInstance)::Model
    model = Model(optimizer)

    # Define variables
    @variable(model, y[instance.arcs], Bin)  # Design variable as integer
    @variable(model, x[instance.arcs, instance.commodities] >= 0)  # Flow on arcs

    # Objective: Minimize total cost
    @objective(model, Min, 
    sum(arc.variable_cost * x[arc, commodity] + arc.fixed_cost * y[arc] for arc in instance.arcs for commodity in instance.commodities))

    # Demand and flow conservation constraints
    for node in instance.nodes
        for commodity in instance.commodities
            if commodity.origin == node
                w_ik = commodity.demand
            elseif commodity.destination == node
                w_ik = -commodity.demand
            else
                w_ik = 0
            end

            @constraint(model, 
                sum(x[arc, commodity] for arc in instance.arcs if arc.origin == node) - 
                sum(x[arc, commodity] for arc in instance.arcs if arc.destination == node) == w_ik
            )
        end
    end

    # Capacity and linking constraints
    for arc in instance.arcs
        @constraint(model, sum(x[arc, commodity] for commodity in instance.commodities) 
            <= y[arc] * arc.capacity)
    end

    return model
end

function extract_solution(model::Model, instance::McndInstance)::McndSolution
    x_values = Matrix{Int}(undef, length(instance.arcs), length(instance.commodities))
    for (i, arc) in enumerate(instance.arcs)
        for (j, commodity) in enumerate(instance.commodities)
            x_values[i, j] = value(model[:x][arc, commodity])
        end
    end
    y_values = value.(model[:y])
    objective_value = JuMP.objective_value(model)
    solution = McndSolution(instance, objective_value, x_values, y_values)

    return solution
end

#ANCHOR - MCND Function
function create_model(instance::FtpInstance)::Model
    model = Model(optimizer)

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

function extract_solution(model::Model, instance::FtpInstance)::FtpSolution
    x_values = value.(model[:x])
    y_values = value.(model[:y])

    objective_value = JuMP.objective_value(model)
    solution = FtpSolution(instance, objective_value, x_values, y_values)

    return solution
end