from collections import Counter
from typing import List


def find_combination(target: float, candidates: List[float]) -> List:

    def backtrack(remain: float, comb: list, current_index: int, counter: list, results: list):
        if remain == 0:
            results.append(list(comb))
            return
        elif remain < 0:
            return

        # Iterate through the reduced list of candidates.
        for i in range(current_index, len(counter)):
            candidate, freq = counter[i]

            # if freq is less than 0, go to next i
            if freq <= 0:
                continue

            comb.append(candidate)

            counter[i] = (candidate, freq - 1)

            backtrack(round(remain - candidate, 2), comb, i, counter, results)

            # if the function above returns, backtrak.
            counter[i] = (candidate, freq)
            comb.pop()

    counter = Counter(candidates)
    counter = [(c, counter[c]) for c in counter]

    results = []

    backtrack(target, [], 0, counter, results)

    try:
        maxLengthResult = max(results, key=len)
        print(f'Max length combination of prices found: {maxLengthResult}')
    except:
        print('Could not find the combination prices. Returning the original prices')
        return candidates

    return maxLengthResult
