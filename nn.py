
# Bank Customer Churn Prediction using Neural Network

import pandas as pd
import numpy as np

from sklearn.model_selection import train_test_split
from sklearn.preprocessing import StandardScaler, LabelEncoder
from sklearn.metrics import accuracy_score, confusion_matrix

from tensorflow.keras.models import Sequential
from tensorflow.keras.layers import Dense

# 1. Load dataset
data = pd.read_csv("Churn_Modelling.csv")

# 2. Remove unnecessary columns
data = data.drop(['RowNumber', 'CustomerId', 'Surname'], axis=1)

# 3. Encode categorical columns
le = LabelEncoder()
data['Gender'] = le.fit_transform(data['Gender'])

data = pd.get_dummies(data, columns=['Geography'], drop_first=True)

# 4. Separate input and output
X = data.drop('Exited', axis=1)
y = data['Exited']

# 5. Split dataset into training and testing
X_train, X_test, y_train, y_test = train_test_split(
    X, y, test_size=0.2, random_state=42
)

# 6. Normalize the data
sc = StandardScaler()

X_train = sc.fit_transform(X_train)
X_test = sc.transform(X_test)

# 7. Build Neural Network
model = Sequential()

model.add(Dense(16, activation='relu', input_shape=(X_train.shape[1],)))
model.add(Dense(8, activation='relu'))
model.add(Dense(1, activation='sigmoid'))

# 8. Compile model
model.compile(
    optimizer='adam',
    loss='binary_crossentropy',
    metrics=['accuracy']
)

# 9. Train model
model.fit(X_train, y_train, epochs=20, batch_size=32, verbose=1)

# 10. Predict output
y_pred = model.predict(X_test)
y_pred = (y_pred > 0.5).astype(int)

# 11. Calculate accuracy
accuracy = accuracy_score(y_test, y_pred)

print("\nAccuracy:", accuracy * 100, "%")

# 12. Confusion Matrix
cm = confusion_matrix(y_test, y_pred)

print("\nConfusion Matrix:")
print(cm)
