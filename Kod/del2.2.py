import numpy as np

class second_derivative:
    def __init__(self, a_1, a_2, T_inf):
        self.a_1 = a_1
        self.a_2 = a_2
        self.T_inf = T_inf

    def __call__(self, x, y):
        T, s = y
        dTdx =  s
        dsdx =  self.a_1 * (self.T_inf - T) - self.a_2 * (T**4 - self.T_inf**4)
        return [dTdx, dsdx]



def finite_difference(a_1, a_2, T_inf, T_s, L, N=100):
    ''' Calculates the finite difference approximation of the second derivative of T with respect to x.
    parameters:
        a_1: The coefficient of the linear term in the second derivative.
        a_2: The coefficient of the nonlinear term in the second derivative.
        T_inf: The ambient temperature. second boundary condition.
        function: The function that takes in x and y and returns the finite difference approximation of the second derivative of T with respect to x.
        T_s: The initial temperature at x=0. first boundary condition.
        N: The number of points to calculate the finite difference approximation at.
        L: The length of the domain to calculate the finite difference approximation over.
    Returns:
        A function that takes in x and y and returns the finite difference approximation of the second derivative of T with respect to x.
    '''
    x = np.linspace(0, L, N)
    dx = L / (N - 1)
    T = np.zeros(N)
    T[0] = T_s
    T[-1] = T_inf

    # Iterative finite difference method
    for iteration in range(1000):  # Maximum iterations for convergence
        T_old = T.copy()
        for i in range(1, N - 1):
            # Discretized equation: d²T/dx² = a_1*(T_inf - T) - a_2*(T⁴ - T_inf⁴)
            d2Tdx2 = a_1 * (T_inf - T[i]) - a_2 * (T[i]**4 - T_inf**4)
            # Central difference: d²T/dx² ≈ (T[i+1] - 2*T[i] + T[i-1]) / dx²
            T[i] = (T[i+1] + T[i-1] + d2Tdx2 * dx**2) / 2

        # Check convergence
        if np.max(np.abs(T - T_old)) < 1e-6:
            break

    return x, T

def plot_function(x, T):
    import matplotlib.pyplot as plt
    plt.plot(x, T, label='Finite Difference Approximation')
    plt.xlabel('x')
    plt.ylabel('T(x)')
    plt.title('Temperature Distribution')
    plt.legend()
    plt.grid()
    plt.show()

def main():

        D = 5.0*10**(-3)
        K = 240
        h_c = 40
        epsilon = 0.4
        D =4.13*10**(-3)
        T_s = 450
        T_inf = 293

        L = 0.3

        sigma = 5.67*10**(-8) # Stefan-Boltzmann constant
        epsilon = 0.8

        a_2 = 4*epsilon * sigma / (D * K)
        a_1 = 4 * h_c / (D * K)



        second_derivative_func = second_derivative(a_1, a_2, T_inf)

        x = np.linspace(0, 10, 100)
        y = np.zeros((100, 2))
        y[:, 0] = T_s

        for i in range(1, len(x)):
            y[i] = second_derivative_func(x[i], y[i-1])

        print(y)

        # Calculate the finite difference approximation
        x_fd, T_fd = finite_difference(a_1, a_2, T_inf, T_s, L, N=100)
        print("Finite difference approximation of T:", T_fd)

        # Plot the results
        plot_function(x_fd, T_fd)



if __name__ == "__main__":
    main()