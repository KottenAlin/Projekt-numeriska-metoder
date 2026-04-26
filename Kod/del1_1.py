import numpy as np
import matplotlib.pyplot as plt
import scipy.optimize as optimize

# Constants
R_fi = 1.76*10**-4 # Resistivity of copper (Ohm*m)
R_fo = 1.76*10**-4 # Resistivity of copper (Ohm*m)
h_s = 356
h_t = 356
k_w = 60

delta_T_m = 29.6
Q = 801368

D_s = 1.219
A_ex = 64.15

def U_f(d):
    return 1/g(d)

def g(d):
    return (d/(D_s*h_t)+d*R_fi/D_s+d*np.log(d/D_s)/(2*k_w)+R_fo+1/h_s)

# Q = A_ex * U_f(d) * delta_T_m to use newtons method  f(d) = A_ex * U_f(d) * delta_T_m - Q = 0

def f(d):
    return A_ex * U_f(d) * delta_T_m - Q

# Newton's method d_n+1 = d_n - f(d_n)/f'(d_n)
# To calculate f'(d) we need to calculate U_f'(d) = -g'(d)/g(d)^2
def g_prime(d):
    return (1/(D_s*h_t)+R_fi/D_s+(np.log(d/D_s)+1)/(2*k_w))

def f_prime(d):
    return A_ex * (-g_prime(d)/g(d)**2) * delta_T_m
# Initial guess
d_0 = 0.007
tolerance = 1e-8

def plot_function(f, d_range, y_range):
    d_values = np.linspace(d_range[0], d_range[1], 1000)
    f_values = [f(d) for d in d_values]
    # implemenation of y range

    plt.plot(d_values, f_values, label='f(d)')
    plt.axhline(0, color='red', linestyle='--')
    plt.xlabel('d (m)')
    plt.ylabel('f(d)')
    plt.title('Plot of f(d)')
    plt.legend()
    plt.grid()
    plt.show()


def newton_method(d_0, tolerance, max_iter=10000):
    d_n = d_0
    errors = []
    for i in range(max_iter):

        if f_prime(d_n) == 0:  # Avoid division by zero
            print("Derivative is zero. No solution found.")
            return None

        d_next = d_n - f(d_n) / f_prime(d_n) # newtons method formula
        errors.append(abs(d_next - d_n)) # store the error for convergence analysis

        if abs(d_next - d_n) < tolerance:
            print(f"Converged to {d_next} after {i+1} iterations.")
            return d_next, errors

        d_n = d_next

    print("Maximum iterations reached. No solution found.")
    return None

if __name__ == "__main__":
    #plot_function(f)
    result = newton_method(d_0, tolerance)
    if result is not None:
        solution, errors = result
        print(f"Errors: {errors}")

        # calcue order of convergence
        order_of_convergence = np.log(errors[2]/errors[1]) / np.log((errors[1])/errors[0])

        print(f"Solution: {solution}")
        print(f"Order of convergence: {order_of_convergence}")
        print("theoretical order of convergence is 2 for newton's method")
    else:
        print("Newton's method did not converge for the initial guess.")
    optimized_solution = optimize.fsolve(f, d_0)
    print(f"Optimized Solution using fsolve: {optimized_solution[0]}")

    d_range = (0, 2)
    y_range = (-2, 2)
    plot_function(f, d_range, y_range)

    start_guesses = [0.0001, 0.05, 0.4, 0.95, 1.1, 1.5, 3.0 ]
    for start_guess in start_guesses:
        print(40*"-")
        result = newton_method(start_guess, tolerance)
        if result is None:
            print(f"Newton's method did not converge for start guess {start_guess}.")
            continue

        solution, _ = result

        #optimized_solution = optimize.fsolve(f, start_guess)
        print(f"Solution using Newton's method with start guess {start_guess}: {solution}")

        print("value of f at optimized solution: ", f(optimized_solution[0]))
