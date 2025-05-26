# -*- coding: utf-8 -*-
"""
Created on Mon Jan  1 02:53:08 2024

@author: JUNAID AHMED
"""
# -*- coding: utf-8 -*-
"""
Created on Fri Dec 29 01:38:01 2023

@author: JUNAID AHMED
"""


import matplotlib.pyplot as plt
import numpy as np
import pandas
import seaborn as sns
import warnings
import pandas as pd

from mlxtend.plotting import plot_decision_regions
from sklearn.metrics import classification_report, accuracy_score, confusion_matrix
from sklearn.datasets import make_gaussian_quantiles
from sklearn.model_selection import train_test_split
from sklearn.model_selection import cross_val_score, KFold, StratifiedKFold, GridSearchCV
from sklearn.model_selection import ShuffleSplit, StratifiedShuffleSplit
import sklearn.pipeline
import sklearn.preprocessing
import sklearn.linear_model
import sklearn.neural_network
from sklearn.neighbors import KNeighborsClassifier
from sklearn.svm import SVC
import sklearn.model_selection

df = pandas.read_csv('train_file.csv')
Train_data = df.to_numpy();
x1 = Train_data[:,0:17]
X_train = x1.astype("float32")
y1 = Train_data[:,17:20]
y_train = y1.astype("float32")

df1 = pandas.read_csv('test_file.csv')
Test_data = df1.to_numpy();
x1_test = Test_data[:,0:17]
X_test = x1_test.astype("float32")
y1_test = Test_data[:,17:20]
y_test = y1_test.astype("float32")


model_new = sklearn.pipeline.Pipeline([
    #("scaling", sklearn.preprocessing.MinMaxScaler()),
    ('clf', KNeighborsClassifier(n_neighbors=1))
])


#grid_search = GridSearchCV(model_new,
#                           param_grid={"clf__hidden_layer_sizes": hidden_layer_sizes, "clf__activation": activation,
#                                       "clf__alpha": alpha, "clf__batch_size": batch_size, "clf__learning_rate": learning_rate,
#                                       "clf__learning_rate_init": learning_rate_init,"clf__solver": solver},
#                              cv=StratifiedShuffleSplit(n_splits=1, train_size=0.90,random_state=30)
#                              )

#clf =  sklearn.neural_network.MLPClassifier(max_iter=50000,hidden_layer_sizes=[60,20],batch_size=16)
model_new.fit(X_train, y_train)

pred_train = model_new.predict(X_train)
pred_test = model_new.predict(X_test)

predictions = pred_test.reshape(-1,1)

EB_pred = predictions[0:120,0].reshape(-1,1)
HD_pred = predictions[120:320,0].reshape(-1,1)
LB_pred = predictions[320:400,0].reshape(-1,1)

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

Total_accuray = (EB_count + HD_count + LB_count) / (120+200+80)



print("TRAINING\n" + classification_report(y_train, pred_train))
print("TESTING\n" + classification_report(y_test, pred_test))
print("This is final output:",Total_accuray)
print("This is final output:",accuracy_score(y_test, pred_test))

#result = classification_report(y_train, pred_train)
#result1 = pd.DataFrame(result)

train_result = classification_report(y_train, pred_train,output_dict=True)
train_result1 = pandas.DataFrame(train_result).transpose()

test_result = classification_report(y_test, pred_test,output_dict=True)
test_result1 = pandas.DataFrame(test_result).transpose()



train_result1.to_csv('train_result.csv')
test_result1.to_csv('test_result.csv')