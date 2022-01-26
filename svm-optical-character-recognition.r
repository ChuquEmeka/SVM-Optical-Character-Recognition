{
 "cells": [
  {
   "cell_type": "markdown",
   "id": "e588fe28",
   "metadata": {
    "papermill": {
     "duration": 0.051112,
     "end_time": "2022-01-26T15:41:09.191414",
     "exception": false,
     "start_time": "2022-01-26T15:41:09.140302",
     "status": "completed"
    },
    "tags": []
   },
   "source": [
    "## USING SUPPORT VECTOR MACHINES FOR OPTICAL CHARACTER RECOGNITION.\n",
    "\n",
    "#### PRESENTED BY EDEH EMEKA N.\n",
    "\n",
    "##### SVMs are well suited to tackle the challenges of image data. They are capable of learning complex patterns without being overly sensitive to noise.\n",
    "\n",
    "##### I will simulate a process that involves matching glyphs to one of the 26 letters of the English Alphabets."
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 1,
   "id": "e457a04f",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2022-01-26T15:41:09.285942Z",
     "iopub.status.busy": "2022-01-26T15:41:09.284515Z",
     "iopub.status.idle": "2022-01-26T15:41:09.535613Z",
     "shell.execute_reply": "2022-01-26T15:41:09.534188Z"
    },
    "papermill": {
     "duration": 0.300542,
     "end_time": "2022-01-26T15:41:09.535815",
     "exception": false,
     "start_time": "2022-01-26T15:41:09.235273",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [],
   "source": [
    "letter <- read.csv(\"../input/letterdata/letterdata.csv\", stringsAsFactors = TRUE)"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 2,
   "id": "aed75da2",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2022-01-26T15:41:09.671834Z",
     "iopub.status.busy": "2022-01-26T15:41:09.635011Z",
     "iopub.status.idle": "2022-01-26T15:41:09.704988Z",
     "shell.execute_reply": "2022-01-26T15:41:09.700965Z"
    },
    "papermill": {
     "duration": 0.122248,
     "end_time": "2022-01-26T15:41:09.705256",
     "exception": false,
     "start_time": "2022-01-26T15:41:09.583008",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "'data.frame':\t20000 obs. of  17 variables:\n",
      " $ letter: Factor w/ 26 levels \"A\",\"B\",\"C\",\"D\",..: 20 9 4 14 7 19 2 1 10 13 ...\n",
      " $ xbox  : int  2 5 4 7 2 4 4 1 2 11 ...\n",
      " $ ybox  : int  8 12 11 11 1 11 2 1 2 15 ...\n",
      " $ width : int  3 3 6 6 3 5 5 3 4 13 ...\n",
      " $ height: int  5 7 8 6 1 8 4 2 4 9 ...\n",
      " $ onpix : int  1 2 6 3 1 3 4 1 2 7 ...\n",
      " $ xbar  : int  8 10 10 5 8 8 8 8 10 13 ...\n",
      " $ ybar  : int  13 5 6 9 6 8 7 2 6 2 ...\n",
      " $ x2bar : int  0 5 2 4 6 6 6 2 2 6 ...\n",
      " $ y2bar : int  6 4 6 6 6 9 6 2 6 2 ...\n",
      " $ xybar : int  6 13 10 4 6 5 7 8 12 12 ...\n",
      " $ x2ybar: int  10 3 3 4 5 6 6 2 4 1 ...\n",
      " $ xy2bar: int  8 9 7 10 9 6 6 8 8 9 ...\n",
      " $ xedge : int  0 2 3 6 1 0 2 1 1 8 ...\n",
      " $ xedgey: int  8 8 7 10 7 8 8 6 6 1 ...\n",
      " $ yedge : int  0 4 3 2 5 9 7 2 1 1 ...\n",
      " $ yedgex: int  8 10 9 8 10 7 10 7 7 8 ...\n"
     ]
    }
   ],
   "source": [
    "str(letter)"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 3,
   "id": "d99d3500",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2022-01-26T15:41:09.808306Z",
     "iopub.status.busy": "2022-01-26T15:41:09.806381Z",
     "iopub.status.idle": "2022-01-26T15:41:09.832086Z",
     "shell.execute_reply": "2022-01-26T15:41:09.830475Z"
    },
    "papermill": {
     "duration": 0.076684,
     "end_time": "2022-01-26T15:41:09.832234",
     "exception": false,
     "start_time": "2022-01-26T15:41:09.755550",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [
    {
     "data": {
      "text/html": [
       "<style>\n",
       ".dl-inline {width: auto; margin:0; padding: 0}\n",
       ".dl-inline>dt, .dl-inline>dd {float: none; width: auto; display: inline-block}\n",
       ".dl-inline>dt::after {content: \":\\0020\"; padding-right: .5ex}\n",
       ".dl-inline>dt:not(:first-of-type) {padding-left: .5ex}\n",
       "</style><dl class=dl-inline><dt>letter</dt><dd>0</dd><dt>xbox</dt><dd>0</dd><dt>ybox</dt><dd>0</dd><dt>width</dt><dd>0</dd><dt>height</dt><dd>0</dd><dt>onpix</dt><dd>0</dd><dt>xbar</dt><dd>0</dd><dt>ybar</dt><dd>0</dd><dt>x2bar</dt><dd>0</dd><dt>y2bar</dt><dd>0</dd><dt>xybar</dt><dd>0</dd><dt>x2ybar</dt><dd>0</dd><dt>xy2bar</dt><dd>0</dd><dt>xedge</dt><dd>0</dd><dt>xedgey</dt><dd>0</dd><dt>yedge</dt><dd>0</dd><dt>yedgex</dt><dd>0</dd></dl>\n"
      ],
      "text/latex": [
       "\\begin{description*}\n",
       "\\item[letter] 0\n",
       "\\item[xbox] 0\n",
       "\\item[ybox] 0\n",
       "\\item[width] 0\n",
       "\\item[height] 0\n",
       "\\item[onpix] 0\n",
       "\\item[xbar] 0\n",
       "\\item[ybar] 0\n",
       "\\item[x2bar] 0\n",
       "\\item[y2bar] 0\n",
       "\\item[xybar] 0\n",
       "\\item[x2ybar] 0\n",
       "\\item[xy2bar] 0\n",
       "\\item[xedge] 0\n",
       "\\item[xedgey] 0\n",
       "\\item[yedge] 0\n",
       "\\item[yedgex] 0\n",
       "\\end{description*}\n"
      ],
      "text/markdown": [
       "letter\n",
       ":   0xbox\n",
       ":   0ybox\n",
       ":   0width\n",
       ":   0height\n",
       ":   0onpix\n",
       ":   0xbar\n",
       ":   0ybar\n",
       ":   0x2bar\n",
       ":   0y2bar\n",
       ":   0xybar\n",
       ":   0x2ybar\n",
       ":   0xy2bar\n",
       ":   0xedge\n",
       ":   0xedgey\n",
       ":   0yedge\n",
       ":   0yedgex\n",
       ":   0\n",
       "\n"
      ],
      "text/plain": [
       "letter   xbox   ybox  width height  onpix   xbar   ybar  x2bar  y2bar  xybar \n",
       "     0      0      0      0      0      0      0      0      0      0      0 \n",
       "x2ybar xy2bar  xedge xedgey  yedge yedgex \n",
       "     0      0      0      0      0      0 "
      ]
     },
     "metadata": {},
     "output_type": "display_data"
    }
   ],
   "source": [
    "#i will check for missing values\n",
    " sapply(letter, function(x) sum(is.na (x)))"
   ]
  },
  {
   "cell_type": "markdown",
   "id": "67a22933",
   "metadata": {
    "papermill": {
     "duration": 0.046758,
     "end_time": "2022-01-26T15:41:09.925736",
     "exception": false,
     "start_time": "2022-01-26T15:41:09.878978",
     "status": "completed"
    },
    "tags": []
   },
   "source": [
    "**SVM requires all features to be numeric and fairly scaled to a small interval. To a large extent, this dataset is already prepared for evaluation. No missing value is detected. The rescaling will be authomatically handled by the package that will be used for the model fitting. I will next move into the training and testing phase.**"
   ]
  },
  {
   "cell_type": "markdown",
   "id": "a30077ea",
   "metadata": {
    "papermill": {
     "duration": 0.046188,
     "end_time": "2022-01-26T15:41:10.018810",
     "exception": false,
     "start_time": "2022-01-26T15:41:09.972622",
     "status": "completed"
    },
    "tags": []
   },
   "source": [
    "## **MODEL TRAINING**  \n",
    "\n",
    "**The data has already been randomized by Frey and Slate. I will use the first 15,000 observations(75%) as training data and the remaining 5000(25%) as test data.**"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 4,
   "id": "6a780aa3",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2022-01-26T15:41:10.119258Z",
     "iopub.status.busy": "2022-01-26T15:41:10.116972Z",
     "iopub.status.idle": "2022-01-26T15:41:10.140105Z",
     "shell.execute_reply": "2022-01-26T15:41:10.134306Z"
    },
    "papermill": {
     "duration": 0.073955,
     "end_time": "2022-01-26T15:41:10.140261",
     "exception": false,
     "start_time": "2022-01-26T15:41:10.066306",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [],
   "source": [
    "letter_train <- letter[1:15000,]\n",
    "letter_test <- letter[15001:20000,]"
   ]
  },
  {
   "cell_type": "markdown",
   "id": "d0ef4f01",
   "metadata": {
    "papermill": {
     "duration": 0.046269,
     "end_time": "2022-01-26T15:41:10.235689",
     "exception": false,
     "start_time": "2022-01-26T15:41:10.189420",
     "status": "completed"
    },
    "tags": []
   },
   "source": [
    "**To train my model, i will be using the ksvm() function in the kernlab package(developed in R)**"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 5,
   "id": "cc683916",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2022-01-26T15:41:10.334727Z",
     "iopub.status.busy": "2022-01-26T15:41:10.332561Z",
     "iopub.status.idle": "2022-01-26T15:41:55.084580Z",
     "shell.execute_reply": "2022-01-26T15:41:55.082630Z"
    },
    "papermill": {
     "duration": 44.80288,
     "end_time": "2022-01-26T15:41:55.084802",
     "exception": false,
     "start_time": "2022-01-26T15:41:10.281922",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [
    {
     "name": "stderr",
     "output_type": "stream",
     "text": [
      "Installing package into ‘/usr/local/lib/R/site-library’\n",
      "(as ‘lib’ is unspecified)\n",
      "\n"
     ]
    }
   ],
   "source": [
    "install.packages(\"kernlab\")\n"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 6,
   "id": "9b06967d",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2022-01-26T15:41:55.188827Z",
     "iopub.status.busy": "2022-01-26T15:41:55.186894Z",
     "iopub.status.idle": "2022-01-26T15:41:55.601089Z",
     "shell.execute_reply": "2022-01-26T15:41:55.599706Z"
    },
    "papermill": {
     "duration": 0.465392,
     "end_time": "2022-01-26T15:41:55.601228",
     "exception": false,
     "start_time": "2022-01-26T15:41:55.135836",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [],
   "source": [
    "library(\"kernlab\")"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 7,
   "id": "8acaf57a",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2022-01-26T15:41:55.700920Z",
     "iopub.status.busy": "2022-01-26T15:41:55.699029Z",
     "iopub.status.idle": "2022-01-26T15:42:01.463641Z",
     "shell.execute_reply": "2022-01-26T15:42:01.460948Z"
    },
    "papermill": {
     "duration": 5.816171,
     "end_time": "2022-01-26T15:42:01.463888",
     "exception": false,
     "start_time": "2022-01-26T15:41:55.647717",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      " Setting default kernel parameters  \n"
     ]
    }
   ],
   "source": [
    "letter_classifier <- ksvm(letter ~ ., data = letter_train, kernel = 'vanilladot')"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 8,
   "id": "53b37d2d",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2022-01-26T15:42:01.574702Z",
     "iopub.status.busy": "2022-01-26T15:42:01.572820Z",
     "iopub.status.idle": "2022-01-26T15:42:01.592539Z",
     "shell.execute_reply": "2022-01-26T15:42:01.590961Z"
    },
    "papermill": {
     "duration": 0.071729,
     "end_time": "2022-01-26T15:42:01.592689",
     "exception": false,
     "start_time": "2022-01-26T15:42:01.520960",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [
    {
     "data": {
      "text/plain": [
       "Support Vector Machine object of class \"ksvm\" \n",
       "\n",
       "SV type: C-svc  (classification) \n",
       " parameter : cost C = 1 \n",
       "\n",
       "Linear (vanilla) kernel function. \n",
       "\n",
       "Number of Support Vectors : 6618 \n",
       "\n",
       "Objective Function Value : -13.2947 -19.6051 -20.8982 -5.6651 -7.2092 -31.5151 -48.3253 -17.6236 -57.0476 -30.532 -15.7162 -31.49 -28.2706 -45.741 -11.7891 -33.3161 -28.2251 -16.5347 -13.2693 -30.88 -29.4259 -7.7099 -11.1685 -29.4289 -13.0857 -9.2631 -144.1105 -52.7747 -71.052 -109.7783 -158.3152 -51.2839 -39.6499 -67.0061 -23.8637 -27.6083 -26.3461 -35.2626 -38.6346 -116.8967 -173.8336 -214.2196 -20.7925 -10.3812 -53.1156 -12.228 -46.6132 -8.6867 -18.9108 -11.0535 -94.5751 -26.5689 -224.0215 -70.5714 -8.3232 -4.5265 -132.5431 -74.6876 -19.5742 -12.7352 -81.7894 -11.6983 -25.4835 -17.582 -23.934 -27.022 -50.7092 -10.9228 -4.3852 -13.7216 -3.8547 -3.5723 -8.419 -36.9773 -47.1418 -172.6874 -42.457 -44.0342 -42.7695 -13.0527 -16.7534 -78.7849 -101.8146 -32.1141 -30.3349 -104.0695 -32.1258 -24.6301 -32.6087 -17.0808 -5.1347 -40.5505 -6.684 -16.2962 -56.364 -147.3669 -49.0907 -37.8334 -32.8068 -73.248 -127.7819 -10.5342 -5.2495 -11.9568 -30.1631 -135.5915 -51.521 -176.2669 -99.0973 -10.295 -14.5906 -3.7822 -64.1452 -7.4813 -84.9109 -40.9146 -87.2437 -66.8629 -69.9932 -20.5294 -12.7577 -7.0328 -22.9219 -12.3975 -223.9411 -29.9969 -24.0552 -132.6252 -133.7033 -9.2959 -33.1873 -5.8016 -57.3392 -60.9046 -27.1766 -200.8554 -29.9334 -15.9359 -130.0183 -154.4587 -43.5779 -24.4852 -135.7896 -74.1531 -303.5043 -131.4741 -149.5403 -30.4917 -29.8086 -47.3454 -24.6204 -44.2792 -6.2064 -8.6708 -36.4412 -68.712 -179.7303 -44.7489 -84.8608 -136.6786 -569.3398 -113.0779 -138.435 -303.8556 -32.8011 -60.4546 -139.3525 -108.9841 -34.277 -64.9071 -38.6148 -7.5086 -204.222 -12.9572 -29.0252 -2.0352 -5.9916 -14.3706 -21.5773 -57.0064 -19.6546 -178.0543 -19.812 -4.145 -4.5318 -0.8101 -116.8649 -7.8269 -53.3445 -21.4812 -13.5066 -5.3881 -15.1061 -27.6061 -18.9239 -68.8104 -26.1223 -93.0231 -15.1693 -9.7999 -7.6137 -1.5301 -84.9531 -5.4551 -93.187 -93.4153 -43.8334 -23.6706 -59.1468 -22.0933 -47.8381 -219.9936 -39.5596 -47.2643 -34.0752 -20.2532 -11.239 -118.4152 -6.4126 -5.1846 -8.7272 -9.4584 -20.8522 -22.0878 -113.0806 -29.0912 -80.397 -29.6206 -13.7422 -8.9416 -3.0785 -79.842 -6.1869 -13.9663 -63.3665 -93.2067 -11.5593 -13.0449 -48.2558 -2.9343 -8.25 -76.4361 -33.5374 -109.112 -4.1731 -6.1978 -1.2664 -84.1287 -18.3054 -7.2209 -45.5509 -3.3567 -16.8612 -60.5094 -43.9956 -53.0592 -6.1407 -17.4499 -2.3741 -65.023 -102.1593 -103.4312 -23.1318 -17.3394 -50.6654 -31.4407 -57.6065 -19.6857 -5.2667 -4.1767 -55.8445 -30.92 -57.2396 -30.1101 -7.611 -47.7711 -12.1616 -19.1572 -53.5364 -3.8024 -53.124 -225.6075 -12.6791 -11.5852 -16.6614 -9.7186 -65.824 -16.3897 -42.3931 -50.513 -24.752 -14.513 -40.495 -16.5124 -57.1813 -4.7974 -5.2949 -81.7477 -3.272 -6.3448 -1.1259 -114.3256 -22.3232 -339.8619 -31.0491 -31.3872 -4.9625 -82.4936 -123.6225 -72.8463 -23.4836 -33.1608 -11.7133 -19.7607 -1.8599 -50.1148 -8.2868 -143.3592 -1.8508 -1.9699 -9.4175 -0.5202 -25.0654 -30.0489 -5.6248 \n",
       "Training error : 0.129733 "
      ]
     },
     "metadata": {},
     "output_type": "display_data"
    }
   ],
   "source": [
    "letter_classifier"
   ]
  },
  {
   "cell_type": "markdown",
   "id": "e6f76d2b",
   "metadata": {
    "papermill": {
     "duration": 0.048936,
     "end_time": "2022-01-26T15:42:01.690305",
     "exception": false,
     "start_time": "2022-01-26T15:42:01.641369",
     "status": "completed"
    },
    "tags": []
   },
   "source": [
    "## **MODEL PERFORMANCE EVALUATION**"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 9,
   "id": "d70af772",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2022-01-26T15:42:01.793438Z",
     "iopub.status.busy": "2022-01-26T15:42:01.791730Z",
     "iopub.status.idle": "2022-01-26T15:42:02.659483Z",
     "shell.execute_reply": "2022-01-26T15:42:02.655447Z"
    },
    "papermill": {
     "duration": 0.920484,
     "end_time": "2022-01-26T15:42:02.659720",
     "exception": false,
     "start_time": "2022-01-26T15:42:01.739236",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [
    {
     "data": {
      "text/html": [
       "<style>\n",
       ".list-inline {list-style: none; margin:0; padding: 0}\n",
       ".list-inline>li {display: inline-block}\n",
       ".list-inline>li:not(:last-child)::after {content: \"\\00b7\"; padding: 0 .5ex}\n",
       "</style>\n",
       "<ol class=list-inline><li>C</li><li>U</li><li>K</li><li>U</li><li>E</li><li>I</li></ol>\n",
       "\n",
       "<details>\n",
       "\t<summary style=display:list-item;cursor:pointer>\n",
       "\t\t<strong>Levels</strong>:\n",
       "\t</summary>\n",
       "\t<style>\n",
       "\t.list-inline {list-style: none; margin:0; padding: 0}\n",
       "\t.list-inline>li {display: inline-block}\n",
       "\t.list-inline>li:not(:last-child)::after {content: \"\\00b7\"; padding: 0 .5ex}\n",
       "\t</style>\n",
       "\t<ol class=list-inline><li>'A'</li><li>'B'</li><li>'C'</li><li>'D'</li><li>'E'</li><li>'F'</li><li>'G'</li><li>'H'</li><li>'I'</li><li>'J'</li><li>'K'</li><li>'L'</li><li>'M'</li><li>'N'</li><li>'O'</li><li>'P'</li><li>'Q'</li><li>'R'</li><li>'S'</li><li>'T'</li><li>'U'</li><li>'V'</li><li>'W'</li><li>'X'</li><li>'Y'</li><li>'Z'</li></ol>\n",
       "</details>"
      ],
      "text/latex": [
       "\\begin{enumerate*}\n",
       "\\item C\n",
       "\\item U\n",
       "\\item K\n",
       "\\item U\n",
       "\\item E\n",
       "\\item I\n",
       "\\end{enumerate*}\n",
       "\n",
       "\\emph{Levels}: \\begin{enumerate*}\n",
       "\\item 'A'\n",
       "\\item 'B'\n",
       "\\item 'C'\n",
       "\\item 'D'\n",
       "\\item 'E'\n",
       "\\item 'F'\n",
       "\\item 'G'\n",
       "\\item 'H'\n",
       "\\item 'I'\n",
       "\\item 'J'\n",
       "\\item 'K'\n",
       "\\item 'L'\n",
       "\\item 'M'\n",
       "\\item 'N'\n",
       "\\item 'O'\n",
       "\\item 'P'\n",
       "\\item 'Q'\n",
       "\\item 'R'\n",
       "\\item 'S'\n",
       "\\item 'T'\n",
       "\\item 'U'\n",
       "\\item 'V'\n",
       "\\item 'W'\n",
       "\\item 'X'\n",
       "\\item 'Y'\n",
       "\\item 'Z'\n",
       "\\end{enumerate*}\n"
      ],
      "text/markdown": [
       "1. C\n",
       "2. U\n",
       "3. K\n",
       "4. U\n",
       "5. E\n",
       "6. I\n",
       "\n",
       "\n",
       "\n",
       "**Levels**: 1. 'A'\n",
       "2. 'B'\n",
       "3. 'C'\n",
       "4. 'D'\n",
       "5. 'E'\n",
       "6. 'F'\n",
       "7. 'G'\n",
       "8. 'H'\n",
       "9. 'I'\n",
       "10. 'J'\n",
       "11. 'K'\n",
       "12. 'L'\n",
       "13. 'M'\n",
       "14. 'N'\n",
       "15. 'O'\n",
       "16. 'P'\n",
       "17. 'Q'\n",
       "18. 'R'\n",
       "19. 'S'\n",
       "20. 'T'\n",
       "21. 'U'\n",
       "22. 'V'\n",
       "23. 'W'\n",
       "24. 'X'\n",
       "25. 'Y'\n",
       "26. 'Z'\n",
       "\n",
       "\n"
      ],
      "text/plain": [
       "[1] C U K U E I\n",
       "Levels: A B C D E F G H I J K L M N O P Q R S T U V W X Y Z"
      ]
     },
     "metadata": {},
     "output_type": "display_data"
    }
   ],
   "source": [
    "letter_prediction <- predict(letter_classifier, letter_test)\n",
    "head(letter_prediction)"
   ]
  },
  {
   "cell_type": "markdown",
   "id": "54735acb",
   "metadata": {
    "papermill": {
     "duration": 0.050738,
     "end_time": "2022-01-26T15:42:02.802556",
     "exception": false,
     "start_time": "2022-01-26T15:42:02.751818",
     "status": "completed"
    },
    "tags": []
   },
   "source": [
    "**I will examine how well the classifier performed by comparing the predicted letter to the true letter in the test dataset.**"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 10,
   "id": "697f0ab1",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2022-01-26T15:42:02.913994Z",
     "iopub.status.busy": "2022-01-26T15:42:02.912127Z",
     "iopub.status.idle": "2022-01-26T15:42:02.932083Z",
     "shell.execute_reply": "2022-01-26T15:42:02.930519Z"
    },
    "papermill": {
     "duration": 0.076644,
     "end_time": "2022-01-26T15:42:02.932224",
     "exception": false,
     "start_time": "2022-01-26T15:42:02.855580",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [
    {
     "data": {
      "text/plain": [
       "                 \n",
       "letter_prediction   A   B   C   D   E   F   G   H   I   J   K   L   M   N   O\n",
       "                A 191   0   1   0   0   0   0   0   0   1   0   0   1   2   2\n",
       "                B   0 157   0   9   2   0   1   3   0   0   1   0   3   0   0\n",
       "                C   0   0 142   0   5   0  14   3   2   0   2   4   0   0   2\n",
       "                D   1   1   0 196   0   1   4  12   5   3   4   4   0   6   5\n",
       "                E   0   0   8   0 164   2   1   1   0   0   3   5   0   0   0\n",
       "                F   0   0   0   0   0 171   4   2   8   2   0   0   0   0   0\n",
       "                G   1   1   4   1  10   3 150   2   0   0   1   2   1   0   0\n",
       "                H   0   3   0   1   0   2   2 122   0   2   4   2   2   5  23\n",
       "                I   0   0   0   0   0   0   0   0 175  10   0   0   0   0   0\n",
       "                J   2   2   0   0   0   3   0   2   7 158   0   0   0   0   1\n",
       "                K   2   1  11   0   0   0   4   6   0   0 148   0   0   2   0\n",
       "                L   0   0   0   0   1   0   1   1   0   0   0 176   0   0   0\n",
       "                M   0   0   1   1   0   0   1   2   0   0   0   0 177   5   1\n",
       "                N   0   0   0   1   0   1   0   1   0   0   0   0   0 172   0\n",
       "                O   0   0   1   2   0   0   2   1   0   2   0   0   0   1 132\n",
       "                P   0   0   0   1   0   3   1   0   0   0   0   0   0   0   3\n",
       "                Q   0   0   0   0   0   0   9   3   0   0   0   3   0   0   5\n",
       "                R   2   5   0   1   1   0   2   9   0   0  11   0   1   1   1\n",
       "                S   1   2   0   0   1   1   5   0   2   2   0   3   0   0   0\n",
       "                T   0   0   0   0   3   6   0   1   0   0   1   0   0   0   0\n",
       "                U   1   0   3   3   0   0   0   2   0   0   0   0   0   1   0\n",
       "                V   0   0   0   0   0   1   6   3   0   0   0   0   0   3   1\n",
       "                W   0   0   0   0   0   0   1   0   0   0   0   0   2   0   4\n",
       "                X   0   1   0   0   2   0   0   1   3   0   2   6   0   0   1\n",
       "                Y   3   0   0   0   0   0   0   1   0   0   0   0   0   0   0\n",
       "                Z   2   0   0   0   2   0   0   0   3   3   0   0   0   0   0\n",
       "                 \n",
       "letter_prediction   P   Q   R   S   T   U   V   W   X   Y   Z\n",
       "                A   0   5   0   2   1   1   0   1   0   0   0\n",
       "                B   2   4   8   5   0   0   3   0   1   0   0\n",
       "                C   0   0   0   0   0   0   0   0   0   0   0\n",
       "                D   3   1   4   0   0   0   0   0   5   3   1\n",
       "                E   0   6   0  10   0   0   0   0   4   0   3\n",
       "                F  18   0   0   5   2   0   0   0   1   3   0\n",
       "                G   2  11   2   5   3   0   0   0   1   0   0\n",
       "                H   0   2   6   0   4   1   4   0   0   3   0\n",
       "                I   1   0   0   3   0   0   0   0   4   1   1\n",
       "                J   1   4   0   1   0   0   0   0   2   0  11\n",
       "                K   1   1   7   0   1   3   0   0   4   0   0\n",
       "                L   0   1   0   4   0   0   0   0   1   0   1\n",
       "                M   0   0   0   0   0   4   0   8   0   0   0\n",
       "                N   0   0   3   0   0   1   0   2   0   0   0\n",
       "                O   2   4   0   0   0   3   0   0   0   0   0\n",
       "                P 168   1   0   0   1   0   0   0   0   1   0\n",
       "                Q   1 163   0   5   0   0   0   0   0   3   0\n",
       "                R   1   0 176   0   1   0   2   0   0   0   0\n",
       "                S   0  11   0 135   2   0   0   0   2   0  10\n",
       "                T   0   0   0   3 163   1   0   0   0   5   2\n",
       "                U   1   0   0   0   0 197   0   1   1   1   0\n",
       "                V   0   2   1   0   0   0 152   1   0   5   0\n",
       "                W   0   0   0   0   0   4   7 154   0   0   0\n",
       "                X   0   0   1   2   0   0   0   0 160   1   1\n",
       "                Y   6   0   0   0   3   0   0   0   0 157   0\n",
       "                Z   0   1   0  18   3   0   0   0   0   0 164"
      ]
     },
     "metadata": {},
     "output_type": "display_data"
    }
   ],
   "source": [
    "table(letter_prediction, letter_test$letter)"
   ]
  },
  {
   "cell_type": "markdown",
   "id": "340808c6",
   "metadata": {
    "papermill": {
     "duration": 0.053032,
     "end_time": "2022-01-26T15:42:03.038813",
     "exception": false,
     "start_time": "2022-01-26T15:42:02.985781",
     "status": "completed"
    },
    "tags": []
   },
   "source": [
    "**The diagonal numbers(191, 157, 142, 196 etc) show the total number  \n",
    "records where predicted letter matches the true values.  \n",
    "I will obtain the accuracy rate below**"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 11,
   "id": "c1780a95",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2022-01-26T15:42:03.149541Z",
     "iopub.status.busy": "2022-01-26T15:42:03.147948Z",
     "iopub.status.idle": "2022-01-26T15:42:03.161453Z",
     "shell.execute_reply": "2022-01-26T15:42:03.160108Z"
    },
    "papermill": {
     "duration": 0.069934,
     "end_time": "2022-01-26T15:42:03.161609",
     "exception": false,
     "start_time": "2022-01-26T15:42:03.091675",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [],
   "source": [
    "match <- letter_prediction==letter_test$letter"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 12,
   "id": "a0a6935f",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2022-01-26T15:42:03.270659Z",
     "iopub.status.busy": "2022-01-26T15:42:03.269271Z",
     "iopub.status.idle": "2022-01-26T15:42:03.286370Z",
     "shell.execute_reply": "2022-01-26T15:42:03.285051Z"
    },
    "papermill": {
     "duration": 0.072494,
     "end_time": "2022-01-26T15:42:03.286523",
     "exception": false,
     "start_time": "2022-01-26T15:42:03.214029",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [
    {
     "data": {
      "text/plain": [
       "match\n",
       "FALSE  TRUE \n",
       "  780  4220 "
      ]
     },
     "metadata": {},
     "output_type": "display_data"
    }
   ],
   "source": [
    "table(match)\n"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 13,
   "id": "b1222277",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2022-01-26T15:42:03.399645Z",
     "iopub.status.busy": "2022-01-26T15:42:03.397934Z",
     "iopub.status.idle": "2022-01-26T15:42:03.417123Z",
     "shell.execute_reply": "2022-01-26T15:42:03.415568Z"
    },
    "papermill": {
     "duration": 0.076268,
     "end_time": "2022-01-26T15:42:03.417259",
     "exception": false,
     "start_time": "2022-01-26T15:42:03.340991",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [
    {
     "data": {
      "text/plain": [
       "match\n",
       "FALSE  TRUE \n",
       " 15.6  84.4 "
      ]
     },
     "metadata": {},
     "output_type": "display_data"
    }
   ],
   "source": [
    "accuracy <-prop.table(table(match))*100\n",
    "accuracy"
   ]
  },
  {
   "cell_type": "markdown",
   "id": "2a43d938",
   "metadata": {
    "papermill": {
     "duration": 0.05385,
     "end_time": "2022-01-26T15:42:03.525314",
     "exception": false,
     "start_time": "2022-01-26T15:42:03.471464",
     "status": "completed"
    },
    "tags": []
   },
   "source": [
    "##### **The classifier correctly identified 84.4% of the records and wrongly identifeied 15.6% of the records.**"
   ]
  },
  {
   "cell_type": "markdown",
   "id": "3892e72e",
   "metadata": {
    "papermill": {
     "duration": 0.060145,
     "end_time": "2022-01-26T15:42:03.639622",
     "exception": false,
     "start_time": "2022-01-26T15:42:03.579477",
     "status": "completed"
    },
    "tags": []
   },
   "source": [
    "## MODEL PERFORMANCE IMPROVEMENT"
   ]
  },
  {
   "cell_type": "markdown",
   "id": "b4984f19",
   "metadata": {
    "papermill": {
     "duration": 0.053986,
     "end_time": "2022-01-26T15:42:03.747188",
     "exception": false,
     "start_time": "2022-01-26T15:42:03.693202",
     "status": "completed"
    },
    "tags": []
   },
   "source": [
    "**In the previous analysis, i used the simple linear kernel function known as 'vanilladot'. I will be using the Radial Basis Function (RBF) kernel to attempt to improve my model performance.**"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 14,
   "id": "e944f901",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2022-01-26T15:42:03.861276Z",
     "iopub.status.busy": "2022-01-26T15:42:03.859340Z",
     "iopub.status.idle": "2022-01-26T15:42:37.577266Z",
     "shell.execute_reply": "2022-01-26T15:42:37.574708Z"
    },
    "papermill": {
     "duration": 33.77647,
     "end_time": "2022-01-26T15:42:37.577544",
     "exception": false,
     "start_time": "2022-01-26T15:42:03.801074",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [],
   "source": [
    "letter_classifier2 <- ksvm(letter ~., data = letter_train, kernel= \"rbfdot\")"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 15,
   "id": "2778a54d",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2022-01-26T15:42:37.721671Z",
     "iopub.status.busy": "2022-01-26T15:42:37.719652Z",
     "iopub.status.idle": "2022-01-26T15:42:47.298225Z",
     "shell.execute_reply": "2022-01-26T15:42:47.294040Z"
    },
    "papermill": {
     "duration": 9.637935,
     "end_time": "2022-01-26T15:42:47.298506",
     "exception": false,
     "start_time": "2022-01-26T15:42:37.660571",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [],
   "source": [
    "letter_prediction2 <- predict(letter_classifier2, letter_test)"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 16,
   "id": "964a7fe4",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2022-01-26T15:42:47.462755Z",
     "iopub.status.busy": "2022-01-26T15:42:47.460977Z",
     "iopub.status.idle": "2022-01-26T15:42:47.475192Z",
     "shell.execute_reply": "2022-01-26T15:42:47.473743Z"
    },
    "papermill": {
     "duration": 0.072214,
     "end_time": "2022-01-26T15:42:47.475362",
     "exception": false,
     "start_time": "2022-01-26T15:42:47.403148",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [],
   "source": [
    "#I will get the accuracy\n",
    "match2 <- letter_prediction2==letter_test$letter"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 17,
   "id": "36d65b70",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2022-01-26T15:42:47.593751Z",
     "iopub.status.busy": "2022-01-26T15:42:47.591928Z",
     "iopub.status.idle": "2022-01-26T15:42:47.610492Z",
     "shell.execute_reply": "2022-01-26T15:42:47.608887Z"
    },
    "papermill": {
     "duration": 0.078293,
     "end_time": "2022-01-26T15:42:47.610644",
     "exception": false,
     "start_time": "2022-01-26T15:42:47.532351",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [
    {
     "data": {
      "text/plain": [
       "match2\n",
       "FALSE  TRUE \n",
       " 7.22 92.78 "
      ]
     },
     "metadata": {},
     "output_type": "display_data"
    }
   ],
   "source": [
    "prop.table(table(match2))*100"
   ]
  },
  {
   "cell_type": "markdown",
   "id": "2597af30",
   "metadata": {
    "papermill": {
     "duration": 0.055879,
     "end_time": "2022-01-26T15:42:47.725150",
     "exception": false,
     "start_time": "2022-01-26T15:42:47.669271",
     "status": "completed"
    },
    "tags": []
   },
   "source": [
    "By changing the kernel function, i am able to increase my model accuracy from 84.4% to about 93%"
   ]
  }
 ],
 "metadata": {
  "kernelspec": {
   "display_name": "R",
   "language": "R",
   "name": "ir"
  },
  "language_info": {
   "codemirror_mode": "r",
   "file_extension": ".r",
   "mimetype": "text/x-r-source",
   "name": "R",
   "pygments_lexer": "r",
   "version": "4.0.5"
  },
  "papermill": {
   "default_parameters": {},
   "duration": 102.156768,
   "end_time": "2022-01-26T15:42:47.891040",
   "environment_variables": {},
   "exception": null,
   "input_path": "__notebook__.ipynb",
   "output_path": "__notebook__.ipynb",
   "parameters": {},
   "start_time": "2022-01-26T15:41:05.734272",
   "version": "2.3.3"
  }
 },
 "nbformat": 4,
 "nbformat_minor": 5
}
