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

## References
 R. Nair, "Optimal 2-bit branch predictors", IEEE Trans. Computers, vol. 44 no. 5, May, 1995
## Description
Build a two-bit saturating counter.

The counter increments (up to a maximum of 3) when train_valid = 1 and train_taken = 1. It decrements (down to a minimum of 0) when train_valid = 1 and train_taken = 0. When not training (train_valid = 0), the counter keeps its value unchanged.

areset is an asynchronous reset that resets the counter to weakly not-taken (2'b01). Output state[1:0] is the two-bit counter value.
![image](https://user-images.githubusercontent.com/108848834/178614381-e03947a2-56b4-4c56-a346-5fbbd907aa90.png)
# history shift
Branch direction predictors are often structured as tables of counters indexed by the program counter and branch history. The branch history is a sequence of "taken" or "not taken" results from recent branches.

In hardware, the branch history register can be implemented as a N-bit shift register. After each conditional branch direction is predicted, its predicted direction is shifted into the shift register. The shift register thus holds the most recent N branch results.

Additional complexity arises due to pipeline flushes because branch predictions are done speculatively. When a branch misprediction occurs, the processor state needs to be rolled back to the state immediately after the mispredicted branch. This includes rolling back the global history register, which may contain predicted branch results that were shifted-in by branches younger than the mispredicted branch, but now need to be discarded.

We assume here that there is hardware outside of the branch predictor that remembers the state of the branch history register that was used to predict each branch, which is saved for later use for branch predictor training and pipeline flushes. When a branch misprediction occurs, this hardware informs the branch predictor that a branch has mispredicted, the direction the branch should have taken, and the state of the branch history register corresponding to the point in the program immediately before the mispredicted branch.

Of course, since the processor restarts to the point after the mispredicted branch, the branch history register after the pipeline flush needs to have the actual direction of the mispredicted branch appended.

## Description
Build a 32-bit global history shift register, including support for rolling back state in response to a pipeline flush caused by a branch misprediction.

When a branch prediction is made (predict_valid = 1), shift in predict_taken from the LSB side to update the branch history for the predicted branch. (predict_history[0] is the direction of the youngest branch.)

When a branch misprediction occurs (train_mispredicted = 1), load the branch history register with the history after the completion of the mispredicted branch. This is the history before the mispredicted branch (train_history) concatenated with the actual result of the branch (train_taken).

If both a prediction and misprediction occur at the same time, the misprediction takes precedence, because the pipeline flush will also flush out the branch that is currently making a prediction.

predict_history is the value of the branch history register.

areset is an asynchronous reset that resets the history counter to zero.
![image](https://user-images.githubusercontent.com/108848834/178615013-033c62b3-3f67-42dc-a0bc-7b41ae941944.png)


# gshare
Branch direction predictor
A branch direction predictor generates taken/not-taken predictions of the direction of conditional branch instructions. It sits near the front of the processor pipeline, and is responsible for directing instruction fetch down the (hopefully) correct program execution path. A branch direction predictor is usually used with a branch target buffer (BTB), where the BTB predicts the target addresses and the direction predictor chooses whether to branch to the target or keep fetching along the fall-through path.

Sometime later in the pipeline (typically at branch execution or retire), the results of executed branch instructions are sent back to the branch predictor to train it to predict more accurately in the future by observing past branch behaviour. There can also be pipeline flushes when there is a mispredicted branch.

For this exercise, the branch direction predictor is assumed to sit in the fetch stage of a hypothetical processor pipeline shown in the diagram on the right. This exercise builds only the branch direction predictor, indicated by the blue dashed rectangle in the diagram.

The branch direction prediction is a combinational path: The pc register is used to compute the taken/not-taken prediction, which affects the next-pc multiplexer to determine the value of pc in the next cycle.

Conversely, updates to the pattern history table (PHT) and branch history register take effect at the next positive clock edge, as would be expected for state stored in flip-flops.

Gshare predictor
Branch direction predictors are often structured as tables of counters indexed by the program counter and branch history. The table index is a hash of the branch address and history, and tries to give each branch and history combination its own table entry (or at least, reduce the number of collisions). Each table entry contains a two-bit saturating counter to remember the branch direction when the same branch and history pattern executed in the past.

One example of this style of predictor is the gshare predictor[1]. In the gshare algorithm, the branch address (pc) and history bits "share" the table index bits. The basic gshare algorithm computes an N-bit PHT table index by xoring N branch address bits and N global branch history bits together.

The N-bit index is then used to access one entry of a 2N-entry table of two-bit saturating counters. The value of this counter provides the prediction (0 or 1 = not taken, 2 or 3 = taken).

Training indexes the table in a similar way. The training pc and history are used to compute the table index. Then, the two-bit counter at that index is incremented or decremented depending on the actual outcome of the branch.

## References
 S. McFarling, "Combining Branch Predictors", WRL Technical Note TN-36, Jun. 1993
## Description
Build a gshare branch predictor with 7-bit pc and 7-bit global history, hashed (using xor) into a 7-bit index. This index accesses a 128-entry table of two-bit saturating counters (similar to cs450/counter_2bc). The branch predictor should contain a 7-bit global branch history register (similar to cs450/history_shift).

The branch predictor has two sets of interfaces: One for doing predictions and one for doing training. The prediction interface is used in the processor's Fetch stage to ask the branch predictor for branch direction predictions for the instructions being fetched. Once these branches proceed down the pipeline and are executed, the true outcomes of the branches become known. The branch predictor is then trained using the actual branch direction outcomes.

When a branch prediction is requested (predict_valid = 1) for a given pc, the branch predictor produces the predicted branch direction and state of the branch history register used to make the prediction. The branch history register is then updated (at the next positive clock edge) for the predicted branch.

When training for a branch is requested (train_valid = 1), the branch predictor is told the pc and branch history register value for the branch that is being trained, as well as the actual branch outcome and whether the branch was a misprediction (needing a pipeline flush). Update the pattern history table (PHT) to train the branch predictor to predict this branch more accurately next time. In addition, if the branch being trained is mispredicted, also recover the branch history register to the state immediately after the mispredicting branch completes execution.

If training for a misprediction and a prediction (for a different, younger instruction) occurs in the same cycle, both operations will want to modify the branch history register. When this happens, training takes precedence, because the branch being predicted will be discarded anyway. If training and prediction of the same PHT entry happen at the same time, the prediction sees the PHT state before training because training only modifies the PHT at the next positive clock edge. The following timing diagram shows the timing when training and predicting PHT entry 0 at the same time. The training request at cycle 4 changes the PHT entry state in cycle 5, but the prediction request in cycle 4 outputs the PHT state at cycle 4, without considering the effect of the training request in cycle 4.
![image](https://user-images.githubusercontent.com/108848834/178614861-3499371d-d3cc-45b1-934e-bd1503be2a8f.png)

areset is an asynchronous reset that clears the entire PHT to 2b'01 (weakly not-taken). It also clears the global history register to 0.
