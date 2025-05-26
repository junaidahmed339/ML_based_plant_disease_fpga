# -*- coding: utf-8 -*-
"""
Created on Sat Jul 23 10:20:25 2022

@author: jaadi
"""

import matplotlib.pyplot as plt
import numpy as np
from sklearn import datasets
from sklearn.metrics import confusion_matrix
import tensorflow as tf
tf.compat.v1.disable_eager_execution() 
from mlxtend.plotting import plot_decision_regions
import pandas
import seaborn as sns


df = pandas.read_csv('train_file_bin.csv')
Train_data = df.to_numpy();
x1 = Train_data[:,0:17] #exccluding 208 number feature 
x1 = x1.astype("float32")
y1 = Train_data[:,17:20]
y1 = y1.astype("float32")

df1 = pandas.read_csv('test_file_bin.csv')
Test_data = df1.to_numpy();
x1_test = Test_data[:,0:17]
x1_test = x1_test.astype("float32")


#just used for cm
df2 = pandas.read_csv('test_file.csv')
Test_data = df2.to_numpy();
y1_test = Test_data[:,17:20]
y1_test = y1_test.astype("float32")


#iris_data = datasets.load_iris()
#x_variable = np.array([x[0:4] for x in iris_data.data])
#y_variable = np.array(iris_data.target)
#y_variable = np.eye(len(set(y_variable)))[y_variable]
#x_variable = (x_variable - x_variable.min(0)) / x_variable.ptp(0)

#np.random.seed(59)
#train_data = np.random.choice(len(x_variable), round(len(x_variable) * 0.8), replace=False)
#test_data =np.array(list(set(range(len(x_variable))) - set(train_data)))

#x_variable_train = x_variable[train_data]
#x_variable_test = x_variable[test_data]
#y_variable_train = y_variable[train_data]
#y_variable_test = y_variable[test_data]

x_variable_train = x1
x_variable_test  = x1_test
y_variable_train = y1
y_variable_test  = y1_test 

features = len(x_variable_train[0])
k = 7
x_new_train = tf.compat.v1.placeholder(shape=[None, features], dtype=tf.float32)
y_new_train = tf.compat.v1.placeholder(shape=[None, len(y_variable_train[0])], dtype=tf.float32)
x_new_test = tf.compat.v1.placeholder(shape=[None, features], dtype=tf.float32)

# manhattan distance
manht_distance = tf.reduce_sum(tf.abs(tf.subtract(x_new_train, tf.expand_dims(x_new_test, 1))), axis=2)

# nearest k points
_, top_k_indices = tf.nn.top_k(tf.negative(manht_distance), k=k)
top_k_labels = tf.gather(y_new_train, top_k_indices)

predictions_sumup = tf.reduce_sum(top_k_labels, axis=1)
make_prediction = tf.argmax(predictions_sumup, axis=1)


sess = tf.compat.v1.Session()
outcome_prediction = sess.run(make_prediction, feed_dict={x_new_train: x_variable_train,
                               x_new_test: x_variable_test,
                               y_new_train: y_variable_train})


accuracy = 0
for pred, actual in zip(outcome_prediction, y_variable_test):
    if pred == np.argmax(actual):
        accuracy += 1

#print("This is final output:",accuracy / len(outcome_prediction))

y_pred = outcome_prediction.reshape(-1,1)

EB_pred = y_pred[0:150,0].reshape(-1,1)
HD_pred = y_pred[150:350,0].reshape(-1,1)
LB_pred = y_pred[350:430,0].reshape(-1,1)

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



#cm = confusion_matrix(y1_test, y_pred)
#sns.heatmap(cm,annot=True)
#plt.title('Confusion matrix for RBF SVM')
#plt.show(cm)
#print(cm)