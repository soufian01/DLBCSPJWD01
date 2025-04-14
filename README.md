**Installation Instructions**

**Prerequisites**

Before you begin, ensure you have the following tools installed:
Python 3.x (recommended: Python 3.8 or higher)
Download it from python.org and verify with:  
bash

python --version

pip (Python package manager, usually included with Python)
Verify with:  
bash

pip --version

Git (required to clone the repository)
Download it from git-scm.com.

**Installation Steps**

Clone the Repository
Clone the repository for this application:  
bash

git clone https://github.com/soufian01/DLBCSPJWD01.git

Navigate into the project directory:  
bash

cd DLBCSPJWD01

Create a Virtual Environment
Create a virtual environment to isolate dependencies:  
bash

python -m venv venv

**Activate the virtual environment:**

On Windows:  
bash

venv\Scripts\activate

On macOS/Linux:  
bash

source venv/bin/activate

After activation, you’ll see (venv) in your terminal.

**Install Dependencies** 

Ensure the requirements.txt file is present in the project directory, then install the dependencies:  
bash

pip install -r requirements.txt

**Run the Application**

Start the Flask server:  
bash

flask run

Open your browser and go to http://127.0.0.1:5000 (or the URL shown in the terminal).

**Troubleshooting**

Error: "ModuleNotFoundError"
Ensure you’ve activated the virtual environment and installed all dependencies using pip install -r requirements.txt.

Port 5000 in Use
Change the Flask port with:  
bash

flask run --port 5001

