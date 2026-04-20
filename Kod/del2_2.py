#%%
import numpy as np
import matplotlib.pyplot as plt

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
        N: The number of subintervals to calculate the finite difference approximation over.
        L: The length of the domain to calculate the finite difference approximation over.
    Returns:
        A function that takes in x and y and returns the finite difference approximation of the second derivative of T with respect to x.
    '''
    x = np.linspace(0, L, N + 1) # Create a grid of points, where L is the length of the domain and N+1 is the number of points.
    h = L / N # Calculate the step size based on the number of subintervals and the length of the domain.
    T0 = np.zeros(N+1) # Initialize an array to store the temperature values at each point in the grid.
    T0[0] = T_s
    T0[-1] = T_inf

    def T_analytical(x):  # The analytical solution to the simplified problem, which is derived from the linearized version of the heat transfer equation, can be expressed as an exponential decay function. This function describes how the temperature T changes with respect to the distance x along the rod, starting from the initial temperature T_s at x=0 and approaching the ambient temperature T_inf as x increases.
        return T_inf + (T_s - T_inf) * np.exp(-np.sqrt(a_1) * x)


    F_list = []

    def F(T):
        F_vec = np.zeros(N-1)


        for i in range(1, N):
            #test = h**2 * (a_1 * (T_inf - T[i]))
            F_i = (T[i-1] - 2*T[i] + T[i+1]) - h**2 * (a_1 * (T[i]-T_inf) + a_2 * (T[i]**4 - T_inf**4)) # Calculate the finite difference approximation of the second derivative of T with respect to x at point i.
            F_vec[i-1] = F_i

        F_list.append(F_vec)
        return F_vec

    def jacobian(T):
        J = np.zeros((N-1, N-1))
        for i in range(1, N):
            # Calculate the Jacobian matrix of the finite difference approximation of the second derivative of T with respect to x at point i.
            J[i-1, i-1] = -2-h**2*(a_1+a_2*4*T[i]**3) # Calculate the diagonal elements of the Jacobian matrix.

            if i > 1: # Calculate the off-diagonal elements of the Jacobian matrix.
                J[i-1, i-2] = 1

            if i < N-2:
                J[i-1, i] = 1
        return J

    def newton_method(T0, tol=1e-6, max_iter=1000):
        T = T0.copy()
        for _ in range(max_iter):
            F_vec = F(T)
            J = jacobian(T)

            delta_T = np.linalg.solve(J, -F_vec) # Solve the linear system J * delta_T = -F_vec to find the update for T.
            T[1:-1] += delta_T # Update the interior points of T using the calculated delta_T.
            #print("Current T:", T)
            #plot_function(x, T, T_analytical, multiple=False)
            if np.linalg.norm(delta_T) < tol: # Check for convergence by comparing the norm of delta_T to a specified tolerance.
                return T
        print("Warning: Newton's method did not converge within the maximum number of iterations.")
        return T

    # get a start guess for T using the boundary conditions and a linear interpolation between them.
    for i in range(1, N):
        T0[i] = T_s + (T_inf - T_s) * (x[i] / L)

    T = newton_method(T0)

    return x, T



def plot_function(x, T, T_analytical=None, multiple=False):

    if multiple:
        plt.figure(figsize=(12, 6))
        for key in T:
            plt.plot(x, T[key], label=f'Finite Difference Approximation {key}')
    else:
        plt.plot(x, T, label='Finite Difference Approximation')
    if T_analytical is not None:
        plt.plot(x, T_analytical(x), label='Analytical Solution')
    plt.xlabel('x')
    plt.ylabel('T(x)')
    plt.title('Temperature Distribution')
    plt.legend()
    plt.grid()
    plt.show()

def plot_error(x, error, xlabel='x', ylabel='Error', title='Error between Finite Difference and Analytical Solution'):
    import matplotlib.pyplot as plt
    plt.plot(x, error, label='Error')
    plt.xlabel(xlabel)
    plt.ylabel(ylabel)
    plt.title(title)
    plt.legend()
    plt.grid()
    plt.show()
#%%

def main():
        #%%

        T_inf = 293.15 # ambient temperature in Kelvin
        sigma = 5.67*10**(-8) # Stefan-Boltzmann constant


        #%% 8.3
        D = 4.13*10**(-3)
        T_s = 450
        K = 240
        h_c = 40
        epsilon = 0.4
        a_1 = 4 * h_c / (D * K)

        a_2 = 0
        # Since we are ignoring radiation, the coefficient of the nonlinear term in the second derivative is set to zero. which simplifies the problem to a linear one, and we can focus on the convective heat transfer aspect of the problem.
        L = 2.5
        N = 400

        x_fd, T_fd = finite_difference(a_1, a_2, T_inf, T_s, L, N)
        #print("Finite difference approximation of T:", T_fd)

        def T_analytical(x): # The analytical solution to the simplified problem, which is derived from the linearized version of the heat transfer equation, can be expressed as an exponential decay function. This function describes how the temperature T changes with respect to the distance x along the rod, starting from the initial temperature T_s at x=0 and approaching the ambient temperature T_inf as x increases.
            return T_inf + (T_s - T_inf) * np.exp(-np.sqrt(a_1) * x)

        # Plot the results
        plot_function(x_fd, T_fd, T_analytical)

        # Error analysis
        T_analytical_values = T_analytical(x_fd)
        error = np.abs(T_fd - T_analytical_values)
        plot_error(x_fd, error)

        # 8.3.b
        # meansquare error norm (np.mean = )
        rmse = np.mean(error**2)**0.5 # = np.sqrt(1/N-1 * np.sum(error**2)) # Calculate the mean square error norm, which provides a measure of the average magnitude of the errors between the finite difference approximation and the analytical solution. It is computed by taking the square root of the mean of the squared errors, giving us an indication of how well the finite difference method approximates the true solution across the entire domain.
        print("Root Mean Square Error:", rmse)

        #% 8.3.b

        N = [50, 100, 200, 400, 800]
        rmse_values = []
        for n in N:
            x_fd, T_fd = finite_difference(a_1, a_2, T_inf, T_s, L, n)
            T_analytical_values = T_analytical(x_fd)
            error = np.abs(T_fd - T_analytical_values)
            rmse = np.mean(error**2)**0.5
            rmse_values.append(rmse)
            print(f"N={n}, Root Mean Square Error: {rmse:.6e}")

        # Calculate order of convergence
        for i in range(1, len(N)):
            order = np.log(rmse_values[i-1] / rmse_values[i]) / np.log(N[i] / N[i-1])
            print(f"Order of convergence between N={N[i-1]} and N={N[i]}: {order:.2f}")

        plt.plot(N, rmse_values, marker='o')
        plt.xscale('log')
        plt.yscale('log')
        plt.xlabel('Number of Subintervals (N)')
        plt.ylabel('Root Mean Square Error')
        plt.title('Convergence of Finite Difference Method')
        plt.grid()
        plt.show()



        #%% 8.4.a

        L = 0.3 #
        D = 5.0*10**(-3)
        T_0 = 373.15
        N = 400

        # Temperature_distribution with different materials
        materials = {
            'SS AISI 316': {'K': 14, 'h_c': 100, 'epsilon': 0.17},
            'Aluminium': {'K': 180, 'h_c': 100, 'epsilon': 0.85},
            'Copper': {'K': 398, 'h_c': 100, 'epsilon': 0.03}
        }
        Temp_dict = {}
        for material, properties in materials.items():
            K = properties['K']
            h_c = properties['h_c']
            epsilon = properties['epsilon']

            a_1 = 4 * h_c / (D * K)
            a_2 = 4*epsilon * sigma / (D * K)

            x_fd, T_fd = finite_difference(a_1, a_2, T_inf, T_0, L, N)
            Temp_dict[material] = T_fd
        # Plot the results for different materials
        plot_function(x_fd, Temp_dict, multiple=True)
        #print("Finite difference approximation of T:", T_fd)

        #plot the results
        plot_function(x_fd, T_fd)

        def compare_solutions(L1, L2):
            x1, T1 = finite_difference(a_1, a_2, T_inf, T_0, L1, N)
            x2, T2 = finite_difference(a_1, a_2, T_inf, T_0, L2, N)

            # interpolate T2 onto the x1 grid
            #plot_function(x1, {'L1': T1, 'L2': np.interp(x1, x2, T2)}, multiple=True)

            T2_on_x1 = np.interp(x1, x2, T2)

            error = T1 - T2[:len(T1)] # Calculate the error between the two solutions at the corresponding points in the x1 grid.
            rmse = np.sqrt(np.mean(error**2))

            return rmse

        def find_infinite_length(L0=0.1, tol=1e-1):
            L = L0

            max_L = 10.0  # Set a maximum length to prevent infinite loops
            error_list = []
            L_values = []
            while L < max_L:
                err = compare_solutions(L, L+0.1)

                print(f"L={L:.3f}, error={err:.6e}")
                error_list.append(err)
                L_values.append(L)

                if err < tol:
                    break

                L += 0.1
            plot_error(L_values, error_list, xlabel='Length (L)', ylabel='RMSE',
                       title='Error between Solutions for Different Lengths')

            # log log plot of error vs L
            '''error_list = []
            L_values = []
            L_test = L0
            for i in range(15):
                err = compare_solutions(L_test, L_test*2)
                print(f"L={L_test:.3f}, error={err:.6e}")
                error_list.append(err)
                L_values.append(L_test)
                L_test *= 2
            plt.figure(figsize=(8, 6))
            plt.plot(L_values, error_list, marker='o')
            plt.xscale('log')
            plt.yscale('log')
            plt.xlabel('Length (L)')
            plt.ylabel('Root Mean Square Error')
            plt.title('Convergence of Solutions as Length Increases')
            plt.grid()
            plt.show()'''

            return L
        L_infinite = {}

        for material, properties in materials.items():
            K = properties['K']
            h_c = properties['h_c']
            epsilon = properties['epsilon']

            a_1 = 4 * h_c / (D * K)
            a_2 = 4*epsilon * sigma / (D * K)

            L_infinite[material] = find_infinite_length()

        for material, L in L_infinite.items():
            print(f"Estimated length for infinite approximation ({material}): {L:.3f} m")




if __name__ == "__main__":
    try:
        main()
    except KeyboardInterrupt:
        print("Program interrupted by user.")