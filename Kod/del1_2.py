import numpy as np
import matplotlib.pyplot as plt

# Constants
R_fi = 1.76*10**-4  # Resistivity of copper (Ohm*m)
R_fo = 1.76*10**-4  # Resistivity of copper (Ohm*m)
h_s = 356
h_t = 356
k_w = 60

# parameters
c = 0.389
S_t = 0.016
K_1 = 0.249
n_1 = 2.207

# maximal pressure fall
delta_p_max = 49080

# Temperature difference
delta_T = 29.6

# power
Q = 80136

# first function: Q = A_ex(d) * U_f(d) * delta_T => f(d) = A_ex(d) * U_f(d) * delta_T - Q = 0

def U_f(d, D):
    return 1/g(d, D)

def g(d, D):
    return (d/(D*h_t)+d*R_fi/D+d*np.log(d/D)/k_w+R_fo+1/h_s)

# second function: U_f = 1/g(d)

# third function delta_p = B(d, D)
def B(d, D):
    return c/(D**2*(S_t-d)**2)

# forth function A_ex = A(d,D)
def A(d, D):
    return np.pi*K_1*(D**n_1/d**(n_1-1))

# construct a system of equations to solve for d and D F(d, D) = 0

def F_1(d, D):
    return A(d, D) * U_f(d, D) * delta_T - Q

def F_2(d, D):
    return B(d, D) - delta_p_max

def F(d, D):
    return np.array([F_1(d, D), F_2(d, D)])

# Construct the Jacobian matrix for the system of equations, by calculating the partial derivatives of F_1 and F_2 with respect to d and D

# To calculate the partial derivatives we need to calculate the derivatives of A, U_f and B with respect to d and D

def dgdd(d, D):
    return (1/(D*h_t)+R_fi/D+(np.log(d/D)+1)/k_w)

def dgdD(d, D):
    return (-d/(D**2*h_t)-d*R_fi/D**2-d/(D*k_w))

def dAdd(d, D):
    return np.pi*K_1*(1-n_1)*D**(n_1)/d**(n_1)

def dAdD(d, D):
    return np.pi*K_1*n_1*D**(n_1-1)/d**(n_1-1)

# Now we can calculate the partial derivatives of F_1 and F_2 with respect to d and D

def dF1dd(d, D):
    return dAdd(d, D) * g(d,D)-A(d, D) * dgdd(d, D) / g(d, D)**2 * delta_T

def dFdD(d, D):
    return dAdD(d, D) * g(d,D)-A(d, D) * dgdD(d, D) / g(d, D)**2 * delta_T

def dF2dd(d, D):
    return 2*c/(D**2*(S_t-d)**3)

def dF2dD(d, D):
    return -2*c/(D**3*(S_t-d)**2)

# Finally, we can construct the Jacobian matrix for the system of equations F(d, D) = 0
def jacobian(d, D):
    return np.array([[dF1dd(d, D), dFdD(d, D)],
                     [dF2dd(d, D), dF2dD(d, D)]])

# implement the Newton's method for solving the system of equations F(d, D) = 0
def newton_method_system(d_0, D_0, tolerance, max_iter=10000):
    d_n = d_0
    D_n = D_0
    errors = []
    for i in range(max_iter):
        F_n = F(d_n, D_n)
        J_n = jacobian(d_n, D_n)

        if np.linalg.det(J_n) == 0:  # Avoid singular Jacobian
            print("Jacobian is singular. No solution found.")
            return None

        delta = np.linalg.solve(J_n, -F_n)
        d_next = d_n + delta[0]
        D_next = D_n + delta[1]
        errors.append(np.linalg.norm(delta))

        if np.linalg.norm(delta) < tolerance:
            print(f"Converged to (d={d_next}, D={D_next}) after {i+1} iterations.")
            return d_next, D_next, errors

        d_n, D_n = d_next, D_next

    print("Maximum iterations reached. No solution found.")
    return None

def plot_function(F, d_range, D_range):
    d_values = np.linspace(d_range[0], d_range[1], 100)
    D_values = np.linspace(D_range[0], D_range[1], 100)
    F_values = np.zeros((len(d_values), len(D_values)))

    for i in range(len(d_values)):
        for j in range(len(D_values)):
            F_values[i, j] = np.linalg.norm(F(d_values[i], D_values[j]))

    plt.contourf(D_values, d_values, F_values, levels=50, cmap='viridis')
    plt.colorbar(label='|F(d, D)|')
    plt.xlabel('D (m)')
    plt.ylabel('d (m)')
    plt.title('Contour plot of |F(d, D)|')
    plt.show()

def plot_errors(errors):
    plt.plot(errors, label='Error')
    plt.yscale('log')
    plt.xlabel('Iteration')
    plt.ylabel('Error (log scale)')
    plt.title('Convergence of Newton\'s Method')
    plt.legend()
    plt.grid()
    plt.show()

def main():
    # Initial guess
    d_0 = 0.015
    D_0 = 0.8

    tolerance = 1e-8
    result = newton_method_system(d_0, D_0, tolerance)
    if result is not None:
        d_solution, D_solution, errors = result
        print(f"Solution: d = {d_solution}, D = {D_solution}")
        plot_errors(errors)

    # calculate order of convergence
    for i in range(2, len(errors)):
        order_of_convergence = np.log(errors[i]/errors[i-1]) / np.log(errors[i-1]/errors[i-2])
        print(f"Order of convergence at iteration {i}: {order_of_convergence}")

if __name__ == "__main__":
    try:
        main()
    except KeyboardInterrupt:
        print("Process interrupted by user.")
