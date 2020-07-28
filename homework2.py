
# coding: utf-8

# In[ ]:


# 1. read and write


# In[31]:


with open('dog_breeds.txt','r') as reader:
    dog_breeds = reader.readlines()
    print(dog_breeds)


# In[40]:


new_file = []
for line in dog_breeds:
    newline = line.strip()+','+str(len(line))+'\n'
    new_file.append(newline)
    print(newline, end = '')


# In[41]:


write_path = 'dog_breeds_write.txt'
with open(write_path,'w') as writer:
    writer.writelines(reversed(new_file))


# In[ ]:


# 2.connect to db and query


# In[13]:


import mysql.connector
import pandas as pd


# In[11]:


mypassword = 'xxxxxxx'


# In[12]:


cnx = mysql.connector.connect(user = 'root', password = mypassword,
                              host = 'localhost',
                              database = 'classicmodels')


# In[16]:


df = pd.read_sql_query('select * from customers limit 5;', cnx)
df


# In[17]:


cnx.close()

