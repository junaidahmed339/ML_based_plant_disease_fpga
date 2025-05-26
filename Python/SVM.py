import matplotlib.pyplot as plt
import numpy as np
from sklearn.datasets import make_gaussian_quantiles
from sklearn.svm import SVC
from sklearn.model_selection import train_test_split
from sklearn.metrics import confusion_matrix
from sklearn.metrics import accuracy_score
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

# Configuration options
num_samples_total = 2500
cluster_centers = [(5,5), (3,3), (1,5)]
num_classes = len(cluster_centers)

# Create the SVM
svm = SVC(random_state=42, kernel='rbf')

# Fit the data to the SVM classifier
svm = svm.fit(x1, y1)

# Evaluate by means of a confusion matrix
#matrix = plot_confusion_matrix(svm, x1_test, y1_test,
 #                                cmap=plt.cm.Blues,
 #                                normalize='true')
#plt.title('Confusion matrix for RBF SVM')
#plt.show(matrix)
#plt.show()

# Generate predictions
y_pred = svm.predict(x1_test).reshape(-1,1)


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
        
# Evaluate by means of accuracy
Total_accuray = (EB_count + HD_count + LB_count) / (150+200+80) 
accuracy = accuracy_score(y1_test, y_pred)
print(f'Model accuracy: {Total_accuray}')

# Plot decision boundary
#plot_decision_regions(x1_test, y1_test, clf=svm, legend=2)
#plt.show()