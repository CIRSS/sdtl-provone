import pandas as pd

df = pd.read_csv('df.csv')

df['A'] = 3

df['B'] = df.B + 6.5

df['C'] = df.A - df.B

temps = pd.read_csv('temps.csv')

temps = temps.assign(Celsius=((temps.Fahrenheit - 32) * 5 / 9))

temps = temps.assign(Kelvin=(temps.Celsius + 273))

df.to_csv('products/df_updated.csv', index=False)

temps.to_csv('products/temps_updated.csv', index=False)
