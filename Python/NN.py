# -*- coding: utf-8 -*-
"""
Created on Sat Jul 16 18:27:05 2022

@author: jaadi
"""

import matplotlib.pyplot as plt
import numpy as np
import tensorflow as tf
from tensorflow import keras
from tensorflow.keras import layers
from sklearn.metrics import accuracy_score
from sklearn.metrics import confusion_matrix
from mlxtend.plotting import plot_decision_regions

import pandas
df = pandas.read_csv('train_file.csv')
Train_data = df.to_numpy();
x1 = Train_data[:,0:17]
x1 = x1.astype("float32")
y1 = Train_data[:,17:20]
y1 = y1.astype("float32")

df1 = pandas.read_csv('test_file.csv')
Test_data = df1.to_numpy();
x1_test = Test_data[:,0:17]
x1_test = x1_test.astype("float32")
y1_test = Test_data[:,17:20]
y1_test = y1_test.astype("float32")

inputs = keras.Input(shape=(17,))
dense = layers.Dense(30, activation="relu")
x_0 = dense(inputs)
dense2 = layers.Dense(9, activation="relu")
x_1 = dense2(x_0)
outputs = layers.Dense(3)(x_1)
model = keras.Model(inputs=inputs, outputs=outputs, name="NN")
model.summary()


model.compile(
    loss=keras.losses.SparseCategoricalCrossentropy(from_logits=True),
    optimizer=keras.optimizers.RMSprop(learning_rate=0.01),
    #optimizer=keras.optimizers.legacy.SGD(learning_rate=0.1),
    metrics=["accuracy"],
)

history = model.fit(x1, y1, batch_size=64, epochs=4500, validation_split=0.2)

test_scores = model.evaluate(x1_test, y1_test, verbose=2)
print("Test loss:", test_scores[0])
print("Test accuracy:", test_scores[1])

predictions = model.predict(x1_test)
predictions = np.argmax(predictions, axis=1).reshape(-1,1)

EB_pred = predictions[0:150,0].reshape(-1,1)
HD_pred = predictions[150:350,0].reshape(-1,1)
LB_pred = predictions[350:430,0].reshape(-1,1)

EB_count = 0
for x in EB_pred:
    if x == 0:
        EB_count = EB_count + 1 
        
HD_count = 0
for x in HD_pred:
    if x == 1:
        HD_count = HD_count + 1 
    
LB_count = 0
for x in LB_pred:
    if x == 2:
        LB_count = LB_count + 1 

Total_accuray = (EB_count + HD_count + LB_count) / (150+200+80)

print("This is final output:",Total_accuray)
model.layers[1].weights
model.layers[2].weights
model.layers[3].weights

