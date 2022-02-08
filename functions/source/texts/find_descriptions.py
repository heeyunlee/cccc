from typing import List, Dict
from numpy import average


def find_descriptions(texts_with_points: List[Dict], target_prices_with_points: List[Dict]):
    if len(target_prices_with_points) == 0:
        return

    top_left_dxs = [x['points'][0][0] for x in texts_with_points]
    top_right_dxs = [x['points'][1][0] for x in texts_with_points]
    middle_dx = average([min(top_left_dxs), max(top_right_dxs)])

    processed_descriptions = []

    for price_with_point in target_prices_with_points:
        top_left_dy = price_with_point.get('offset')[0][1]
        dy_range = range(round(top_left_dy * 0.975),
                         round(top_left_dy * 1.025))
        description_list = [x.get('text') for x in texts_with_points if (
            x.get('points')[0][1] in dy_range) and (x.get('points')[1][0] < middle_dx)]
        description = ' '.join(description_list)
        processed_descriptions.append(description)

    return processed_descriptions
