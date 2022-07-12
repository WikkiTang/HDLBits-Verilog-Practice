# timer
Implement a timer that counts down for a given number of clock cycles, then asserts a signal to indicate that the given duration has elapsed. A good way to implement this is with a down-counter that asserts an output signal when the count becomes 0.

At each clock cycle:

If load = 1, load the internal counter with the 10-bit data, the number of clock cycles the timer should count before timing out. The counter can be loaded at any time, including when it is still counting and has not yet reached 0.
If load = 0, the internal counter should decrement by 1.
The output signal tc ("terminal count") indicates whether the internal counter has reached 0. Once the internal counter has reached 0, it should stay 0 (stop counting) until the counter is loaded again.

Below is an example of what happens when asking the timer to count for 3 cycles:
![image](https://user-images.githubusercontent.com/108848834/178614306-bcd4a7ca-e8f0-4161-97f9-7f56d8a659d6.png)
# counter 2bc
Branch direction predictors are often structured as tables of counters indexed by the program counter and branch history. Each table entry usually uses two-bits of state because one-bit of state (remember last outcome) does not have enough hysteresis and flips states too easily.


State diagram of a two-bit saturating counter. The four states are Strong/Weak Taken (T)/Not-Taken (NT).
A two-bit state machine that works fairly well is a saturating counter[1], which counts up to 3 (or 2'b11) or down to 0 (or 2'b00) but does not wrap around. A "taken" result increments the counter, while a "not-taken" result decrements the counter. A branch is predicted to be taken when the count is 2 or 3 (or 2'b1x). Adding some hysteresis prevents a flipping of the prediction when a strongly-biased branch occasionally takes a different direction, requiring two increments in the opposite direction before the prediction is flipped.

References
 R. Nair, "Optimal 2-bit branch predictors", IEEE Trans. Computers, vol. 44 no. 5, May, 1995
Description
Build a two-bit saturating counter.

The counter increments (up to a maximum of 3) when train_valid = 1 and train_taken = 1. It decrements (down to a minimum of 0) when train_valid = 1 and train_taken = 0. When not training (train_valid = 0), the counter keeps its value unchanged.

areset is an asynchronous reset that resets the counter to weakly not-taken (2'b01). Output state[1:0] is the two-bit counter value.
![image](https://user-images.githubusercontent.com/108848834/178614381-e03947a2-56b4-4c56-a346-5fbbd907aa90.png)
