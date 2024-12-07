# Import Python packages
import numpy as np
import pandas as pd

# Load files
left = pd.read_csv('', error_bad_lines=False)  # Insert path of the files
right = pd.read_csv('', error_bad_lines=False)

# Set function
def dataframe_difference(df1, df2, which=None):
    """Find rows which are different between two DataFrames."""
    comparison_df = df1.merge(df2,
                              indicator=True,
                              how='outer')
    if which is None:
        diff_df = comparison_df[comparison_df['_merge'] != 'both']
    else:
        diff_df = comparison_df[comparison_df['_merge'] == which]
    # Uncomment this line to get the file containing different rows between the two files compared:
    # diff_df.to_csv('diff.csv')
    return diff_df
  
# Run function
dataframe_difference(left, right)
# if the two files are identical, the result below and diff file will be blank / columns' names only