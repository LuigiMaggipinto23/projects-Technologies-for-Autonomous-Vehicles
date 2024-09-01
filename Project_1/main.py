
# 1 - Import the needed libraries

import cv2
import mediapipe as mp
import numpy as np
import time
import statistics as st
import os

# 2 - Set the desired setting

mp_face_mesh = mp.solutions.face_mesh

face_mesh = mp_face_mesh.FaceMesh(
    max_num_faces=1,
    refine_landmarks=True,  # Enables  detailed eyes points
    min_detection_confidence=0.5,
    min_tracking_confidence=0.5
)

mp_drawing_styles = mp.solutions.drawing_styles
mp_drawing = mp.solutions.drawing_utils
drawing_spec = mp_drawing.DrawingSpec(thickness=1, circle_radius=1)

#Variables
PERCLOS_cnt = 0
FRAME_cnt = 0
right_eye_dict = dict()
left_eye_dict = dict()
ear_max=0
ear_min=100
t1=0
t2=0
t3=0
t4=0
state=0
perclos=-1
start_ear=-1
flag=0
drowsy=0
distracted_face=0
look_down_flag=0
start_look_down=0
flag_distracted1=0
flag_distracted2=0
start_distracted1=0
start_distracted2=0
saturation_counter=0
entrato=0
# 3 - Open the video source

cap = cv2.VideoCapture(0)  # Local webcam (index start from 0)

# 4 - Iterate (within an infinite loop)

while cap.isOpened():

    # 4.1 - Get the new frame
    success, image = cap.read()
    start = time.time()

    # Also convert the color space from BGR to RGB

    if image is None:
        break

    # To improve performance
    image.flags.writeable = False

    # 4.2 - Run MediaPipe on the frame
    results = face_mesh.process(image)

    # To improve performance
    image.flags.writeable = True

    img_h, img_w, img_c = image.shape

    point_RER = []  # Right Eye Right
    point_REB = []  # Right Eye Bottom
    point_REL = []  # Right Eye Left
    point_RET = []  # Right Eye Top

    point_LER = []  # Left Eye Right
    point_LEB = []  # Left Eye Bottom
    point_LEL = []  # Left Eye Left
    point_LET = []  # Left Eye Top

    point_REIC = []  # Right Eye Iris Center
    point_LEIC = []  # Left Eye Iris Center

    #Vector Variables
    face_2d = []
    face_3d = []
    right_eye_2d = []
    right_eye_3d = []
    left_eye_2d = []
    left_eye_3d = []

    # 4.3 - Get the landmark coordinates

    if results.multi_face_landmarks:
        for face_landmarks in results.multi_face_landmarks:
            for idx, lm in enumerate(face_landmarks.landmark):

                # Eye Gaze (Iris Tracking)

                # Left eye indices list
                # LEFT_EYE =[ 362, 382, 381, 380, 374, 373, 390, 249, 263, 466, 388, 387, 386, 385,384, 398 ]

                # Right eye indices list

                # RIGHT_EYE=[ 33, 7, 163, 144, 145, 153, 154, 155, 133, 173, 157, 158, 159, 160, 161 , 246 ]
                # LEFT_IRIS = [473, 474, 475, 476, 477]
                # RIGHT_IRIS = [468, 469, 470, 471, 472]

                if idx == 33:
                    point_RER = (lm.x * img_w, lm.y * img_h, lm.z*3000)
                    #cv2.circle(image, (int(lm.x * img_w), int(lm.y * img_h)), radius=5, color=(0, 0, 255), thickness=-1)

                if idx == 145:
                    point_REB = (lm.x * img_w, lm.y * img_h, lm.z*3000)
                    #cv2.circle(image, (int(lm.x * img_w), int(lm.y * img_h)), radius=5, color=(0, 0, 255), thickness=-1)

                if idx == 133:
                    point_REL = (lm.x * img_w, lm.y * img_h, lm.z*3000)
                    #cv2.circle(image, (int(lm.x * img_w), int(lm.y * img_h)), radius=5, color=(0, 0, 255), thickness=-1)

                if idx == 159:
                    point_RET = (lm.x * img_w, lm.y * img_h, lm.z*3000)
                    #cv2.circle(image, (int(lm.x * img_w), int(lm.y * img_h)), radius=5, color=(0, 0, 255), thickness=-1)

                if idx == 362:
                    point_LER = (lm.x * img_w, lm.y * img_h, lm.z*3000)
                    # cv2.circle(image, (int(lm.x * img_w), int(lm.y * img_h)), radius=5, color=(0, 0, 255), thickness=-1)

                if idx == 374:
                    point_LEB = (lm.x * img_w, lm.y * img_h, lm.z*3000)
                    # cv2.circle(image, (int(lm.x * img_w), int(lm.y * img_h)), radius=5, color=(0, 0, 255), thickness=-1)

                if idx == 263:
                    point_LEL = (lm.x * img_w, lm.y * img_h, lm.z*3000)
                    # cv2.circle(image, (int(lm.x * img_w), int(lm.y * img_h)), radius=5, color=(0, 0, 255), thickness=-1)

                if idx == 386:
                    point_LET = (lm.x * img_w, lm.y * img_h, lm.z*3000)
                    # cv2.circle(image, (int(lm.x * img_w), int(lm.y * img_h)), radius=5, color=(0, 0, 255), thickness=-1)

                if idx == 468:
                    point_REIC = (lm.x * img_w, lm.y * img_h)
                    # cv2.circle(image, (int(lm.x * img_w), int(lm.y * img_h)), radius=5, color=(255, 255, 0), thickness=-1)

                if idx == 469:
                    point_469 = (lm.x * img_w, lm.y * img_h)
                    # cv2.circle(image, (int(lm.x * img_w), int(lm.y * img_h)), radius=5, color=(0, 255, 0), thickness=-1)

                if idx == 470:
                    point_470 = (lm.x * img_w, lm.y * img_h)
                    # cv2.circle(image, (int(lm.x * img_w), int(lm.y * img_h)), radius=5, color=(0, 255, 0), thickness=-1)

                if idx == 471:
                    point_471 = (lm.x * img_w, lm.y * img_h)
                    # cv2.circle(image, (int(lm.x * img_w), int(lm.y * img_h)), radius=5, color=(0, 255, 0), thickness=-1)

                if idx == 472:
                    point_472 = (lm.x * img_w, lm.y * img_h)
                    # cv2.circle(image, (int(lm.x * img_w), int(lm.y * img_h)), radius=5, color=(0, 255, 0), thickness=-1)

                if idx == 473:
                    point_LEIC = (lm.x * img_w, lm.y * img_h)
                    # cv2.circle(image, (int(lm.x * img_w), int(lm.y * img_h)), radius=5, color=(0, 255, 255), thickness=-1)

                if idx == 474:
                    point_474 = (lm.x * img_w, lm.y * img_h)
                    # cv2.circle(image, (int(lm.x * img_w), int(lm.y * img_h)), radius=5, color=(255, 0, 0), thickness=-1)

                if idx == 475:
                    point_475 = (lm.x * img_w, lm.y * img_h)
                    # cv2.circle(image, (int(lm.x * img_w), int(lm.y * img_h)), radius=5, color=(255, 0, 0), thickness=-1)

                if idx == 476:
                    point_476 = (lm.x * img_w, lm.y * img_h)
                    # cv2.circle(image, (int(lm.x * img_w), int(lm.y * img_h)), radius=5, color=(255, 0, 0), thickness=-1)

                if idx == 477:
                    point_477 = (lm.x * img_w, lm.y * img_h)
                    # cv2.circle(image, (int(lm.x * img_w), int(lm.y * img_h)), radius=5, color=(255, 0, 0), thickness=-1)

                if idx == 33 or idx == 263 or idx == 1 or idx == 61 or idx == 291 or idx == 199:
                    if idx == 1:
                        nose_2d = (lm.x * img_w, lm.y * img_h)
                        nose_3d = (lm.x * img_w, lm.y * img_h, lm.z * 3000)
                    x, y = int(lm.x * img_w), int(lm.y * img_h)
                    face_2d.append([x, y]) 
                    face_3d.append([x, y, lm.z]) 

                # LEFT_IRIS = [473, 474, 475, 476, 477]
                # LEFT EYE
                if idx == 473:
                    left_pupil_2d = (lm.x * img_w, lm.y * img_h)
                    left_pupil_3d = (lm.x * img_w, lm.y * img_h, lm.z * 3000)

                if idx == 362 or idx == 385 or idx == 387 or idx == 263 or idx == 373 or idx == 380:
                    x, y = int(lm.x * img_w), int(lm.y * img_h)
                    left_eye_2d.append([x, y])
                    left_eye_3d.append([x, y, lm.z])

                    if idx == 362:
                        left_eye_dict['1'] = np.array([x, y])
                    if idx == 385:
                        left_eye_dict['2'] = np.array([x, y])
                    if idx == 387:
                        left_eye_dict['3'] = np.array([x, y])
                    if idx == 263:
                        left_eye_dict['4'] = np.array([x, y])
                    if idx == 373:
                        left_eye_dict['5'] = np.array([x, y])
                    if idx == 380:
                        left_eye_dict['6'] = np.array([x, y])

                # RIGHT_IRIS = [468, 469, 470, 471, 472]
                # RIGHT EYE
                if idx == 468:
                     right_pupil_2d = (lm.x * img_w, lm.y * img_h)
                     right_pupil_3d = (lm.x * img_w, lm.y * img_h, lm.z * 3000)

                if idx == 33 or idx == 160 or idx == 158 or idx == 133 or idx == 153 or idx == 144:
                    x, y = int(lm.x * img_w), int(lm.y * img_h)
                    right_eye_2d.append([x, y])
                    right_eye_3d.append([x, y, lm.z])

                    if idx == 33:
                        right_eye_dict['4'] = np.array([x, y])
                    if idx == 160:
                        right_eye_dict['3'] = np.array([x, y])
                    if idx == 158:
                        right_eye_dict['2'] = np.array([x, y])
                    if idx == 133:
                        right_eye_dict['1'] = np.array([x, y])
                    if idx == 153:
                        right_eye_dict['6'] = np.array([x, y])
                    if idx == 144:
                        right_eye_dict['5'] = np.array([x, y])


            
            # 4.4. - Draw the positions on the frame
            l_eye_width = point_LEL[0] - point_LER[0]
            l_eye_height = point_LEB[1] - point_LET[1]
            l_eye_center = np.array([(point_LEL[0] + point_LER[0]) / 2, (point_LEB[1] + point_LET[1]) / 2])
            r_eye_width = point_REL[0] - point_RER[0]
            r_eye_height = point_REB[1] - point_RET[1]
            r_eye_center = np.array([(point_REL[0] + point_RER[0]) / 2, (point_REB[1] + point_RET[1]) / 2])

            #3d eye center
            r_eye_center_3d = np.array([(point_REL[0] + point_RER[0]) / 2,
                                        (point_REB[1] + point_RET[1]) / 2,
                                        (point_REL[2] + point_RER[2] + point_REB[2] + point_RET[2]) / 4])
            l_eye_center_3d = np.array([(point_LEL[0] + point_LER[0]) / 2,
                                        (point_LEB[1] + point_LET[1]) / 2,
                                        (point_LEL[2] + point_LER[2] + point_LEB[2] + point_LET[2]) / 4])


            #Drawing center of the iris and of the eye
            cv2.circle(image, (int(point_LEIC[0]), int(point_LEIC[1])), radius=3, color=(0, 255, 0),
                       thickness=-1)  # Center of iris L
            cv2.circle(image, (int(l_eye_center[0]), int(l_eye_center[1])), radius=2, color=(128, 128, 128),
                        thickness=-1)  # Center of eye L
            cv2.circle(image, (int(point_REIC[0]), int(point_REIC[1])), radius=3, color=(0, 255, 0),
                       thickness=-1)  # Center of iris R
            cv2.circle(image, (int(r_eye_center[0]), int(r_eye_center[1])), radius=2, color=(128, 128, 128),
                       thickness=-1) # Center of eye R

            # EYE GAZE

            #2d Warning left and right
            if l_eye_width < 65 and r_eye_width < 65: 

                right_dist = np.linalg.norm(r_eye_center-np.array([right_pupil_2d[0], right_pupil_2d[1]]))
                left_dist = np.linalg.norm(l_eye_center-np.array([left_pupil_2d[0], left_pupil_2d[1]]))

                if (right_dist>6.0 or left_dist*0.7>6.0) and distracted_face==0 and drowsy==0:
                    if flag_distracted1==0:
                        start_distracted1=time.time()
                        flag_distracted1=1
                    elif flag_distracted1==1 and time.time()-start_distracted1>0.2:
                        if FRAME_cnt%3!=0:
                            cv2.putText(image, f'!!!WARNING THE DRIVER IS DISTRACTED!!!', (2, 400), cv2.FONT_HERSHEY_SIMPLEX, 2, (0, 0, 255), 4)
                else:
                    flag_distracted1=0

            #3d Warning left and right
            else:
                right_dist = np.linalg.norm(r_eye_center_3d-np.array([right_pupil_3d[0], right_pupil_3d[1], right_pupil_3d[2]]))
                left_dist = np.linalg.norm(l_eye_center_3d-np.array([left_pupil_3d[0], left_pupil_3d[1], left_pupil_3d[2]]))
                
                if (right_dist>12.0 or left_dist*0.7>12.0) and distracted_face==0 and drowsy==0:
                    if flag_distracted1==0:
                        start_distracted1=time.time()
                        flag_distracted1=1
                    elif flag_distracted1==1 and time.time()-start_distracted1>0.2:
                        if FRAME_cnt%3!=0:
                            cv2.putText(image, f'!!!WARNING THE DRIVER IS DISTRACTED!!!', (2, 400), cv2.FONT_HERSHEY_SIMPLEX, 2, (0, 0, 255), 4)
                else:
                    flag_distracted1=0

            # convert into numpy arrays
            face_2d = np.array(face_2d, dtype=np.float64)
            face_3d = np.array(face_3d, dtype=np.float64)
            left_eye_2d = np.array(left_eye_2d, dtype=np.float64)
            left_eye_3d = np.array(left_eye_3d, dtype=np.float64)
            right_eye_2d = np.array(right_eye_2d, dtype=np.float64)
            right_eye_3d = np.array(right_eye_3d, dtype=np.float64)

            # define camera matrix
            focal_length = 1 * img_w
            cam_matrix = np.array([[focal_length, 0, img_h / 2],
                                   [0, focal_length, img_w / 2],
                                   [0, 0, 1]])

            dist_matrix = np.zeros((4, 1), dtype=np.float64)

            # solve PnP
            success, rot_vec, trans_vec = cv2.solvePnP(face_3d, face_2d, cam_matrix, dist_matrix)
            success_le, rot_vec_le, trans_vec_le = cv2.solvePnP(left_eye_3d, left_eye_2d, cam_matrix, dist_matrix)
            success_re, rot_vec_re, trans_vec_re = cv2.solvePnP(right_eye_3d, right_eye_2d, cam_matrix, dist_matrix)

            # get rotational matrix
            rmat, jac = cv2.Rodrigues(rot_vec)
            rmat_le, jac_le = cv2.Rodrigues(rot_vec_le)
            rmat_re, jac_re = cv2.Rodrigues(rot_vec_re)

            # get angles
            angles, mtxR, mtxQ, Qx, Qy, Qz = cv2.RQDecomp3x3(rmat)
            angles_le, mtxR_le, mtxQ_le, Qx_le, Qy_le, Qz_le = cv2.RQDecomp3x3(rmat_le)
            angles_re, mtxR_re, mtxQ_re, Qx_re, Qy_re, Qz_re = cv2.RQDecomp3x3(rmat_re)

            pitch = angles[0] * 1800
            yaw = -angles[1] * 1800
            roll = 180 + (np.arctan2(point_RER[1] - point_LEL[1], point_RER[0] - point_LEL[0]) * 180 / np.pi)
            if roll > 180:
                roll -= 360

            pitch_le = angles_le[0] * 1800
            yaw_le = angles_le[1] * 1800

            pitch_re = angles_re[0] * 1800
            yaw_re = angles_re[1] * 1800

            # DISPLAY direction

            # Nose direction
            #nose_3d_projection, jacobian_n = cv2.projectPoints(nose_3d, rot_vec, trans_vec, cam_matrix, dist_matrix)
            p1n = (int(nose_2d[0]), int(nose_2d[1]))
            p2n = (int(nose_2d[0] - yaw * 10), int(nose_2d[1] - pitch * 10)) #Farlo speculare
            #cv2.line(image, p1n, p2n, (255, 0, 0), 3) 

            # Left pupil direction
           #left_pupil_3d_projection, jacobian_l = cv2.projectPoints(left_pupil_3d, rot_vec_le, trans_vec_le, cam_matrix, dist_matrix)
            p1l = (int(left_pupil_2d[0]), int(left_pupil_2d[1]))
            p2l = (int(left_pupil_2d[0] + yaw_le * 10), int(left_pupil_2d[1] - pitch_le * 10)) #Farlo speculare
            #cv2.line(image, p1l, p2l, (255, 0, 0), 3)

            # Right pupil direction
            #right_pupil_3d_projection, jacobian_r = cv2.projectPoints(right_pupil_3d, rot_vec_re, trans_vec_re, cam_matrix, dist_matrix)
            p1r = (int(right_pupil_2d[0]), int(right_pupil_2d[1]))
            p2r = (int(right_pupil_2d[0] + yaw_re * 10), int(right_pupil_2d[1] - pitch_re * 10)) #Farlo speculare
            #cv2.line(image, p1r, p2r, (255, 0, 0), 3)

            # speed reduction (comment out for full speed)
            time.sleep(1 / 25)  # [s]
            if FRAME_cnt>200:
                FRAME_cnt=0
            FRAME_cnt+=1


            # EAR
            ear_le = (np.linalg.norm(left_eye_dict['2'] - left_eye_dict['6']) \
                      + np.linalg.norm(left_eye_dict['3'] - left_eye_dict['5'])) \
                     / (2 * np.linalg.norm(left_eye_dict['1'] - left_eye_dict['4']))

            ear_re = (np.linalg.norm(right_eye_dict['2'] - right_eye_dict['6']) \
                      + np.linalg.norm(right_eye_dict['3'] - right_eye_dict['5'])) \
                     / (2 * np.linalg.norm(right_eye_dict['1'] - right_eye_dict['4']))

            
            # PERCLOS
            end = time.time()
            totalTime = end - start

            ear_m= (ear_le+ear_re)/2 #Ear mean

            if ear_max<ear_m:
                if ear_m<0.40: #Up Treshold 
                    ear_max=ear_m #Set max ear

            if ear_min>ear_m: 
                ear_min=ear_m #Set min ear

            #State Machine to evaluate the PERCLOS

            if (ear_m>0.2 and state==0):
                state=1

            if ear_m<ear_max*0.8 and state==1:
                state=2

            if ear_m<ear_max*0.2 and state==2:
                state=3

            if ear_m>ear_max*0.2 and ear_m<ear_max*0.8 and state==3:
                state=4

            if ear_m>ear_max*0.8 and state!=0:
                if t1>0 and t2>0 and t3>0 and t4>0 and state==4 and t2>0.1 and t3>0.1:
                    perclos=(t3-t2)/((t4+t3)-t1)
                    entrato=0
                    t1=0
                    t2=0
                    t3=0
                    t4=0
                if state!=1:
                    t1=0
                    t2=0
                    t3=0
                    t4=0
                state=1


            if state==1:
                t1+=totalTime
            if state==2:
                t2+=totalTime
            if state==3:
                t3+=totalTime
            if state==4:
                t4+=totalTime

            #Warning if the driver is drowsy->Ear:m less than 40% of Ear_max for 10 seconds straight

            if  flag==0 and ear_m<ear_max*0.4:
                start_ear=time.time()
                flag=1

            if flag==1 and ear_m<ear_max*0.4:
                if time.time()-start_ear>=10.0:
                    if FRAME_cnt%3!=0:
                        drowsy=1
                        cv2.putText(image, f'!!!WARNING THE DRIVER IS DROWSY!!!', (50, 400), cv2.FONT_HERSHEY_SIMPLEX, 2, (0, 0, 255), 4)
                else:
                    drowsy=0
            elif flag==1 and ear_m>ear_max*0.4:
                flag=0


            #ANGLES TO DETECT

            #ROLL TO THE LEFT MAX -> -45° 
            #ROLL TO THE RIGHT MAX -> 50° 

            #YAW TO THE LEFT MAX -> 75° 
            #YAW TO THE RIGHT MAX -> -47° 

            #PITCH TO THE FLOOR -> -20° 
            #PITCH TO THE ROOF -> 60° 

            if roll<=-45.0 or roll>=50.0 or yaw>=75.0 or yaw<=-47.0 or pitch<=-20.0 or pitch>=60.0:
                distracted_face=1
                if flag_distracted2==0:
                    start_distracted2=time.time()
                    flag_distracted2=1
                elif flag_distracted2==1 and time.time()-start_distracted2>0.2:
                     if FRAME_cnt%3!=0 and drowsy==0:
                        cv2.putText(image, f'!!!WARNING THE DRIVER IS DISTRACTED!!!', (2, 400), cv2.FONT_HERSHEY_SIMPLEX, 2, (0, 0, 255), 4)
            else:
                distracted_face=0
                flag_distracted2=0


            cv2.putText(image, "ROLL:" + str(int(roll)) + ", PITCH:" + str(
                    int(pitch))+", YAW:"+ str(int(yaw)), (20, 50), cv2.FONT_HERSHEY_SIMPLEX, 1, (255, 255, 255), 2)

            if perclos!=-1:
                if perclos>0:
                    if (perclos*100)<=100.0:
                        cv2.putText(image, f'PERCLOS: {perclos*100:.4f}%', (20, 140), cv2.FONT_HERSHEY_SIMPLEX, 1, (0, 0, 255), 2)
                        saturation_counter=0
                    else:
                        #In this case the perclos is greater than 100%, so i saturate to 100%
                        cv2.putText(image, f'PERCLOS: 100%', (20, 140), cv2.FONT_HERSHEY_SIMPLEX, 1, (0, 0, 255), 2)
                        if entrato==0:
                            saturation_counter+=1
                            entrato=1
                        cv2.putText(image, f'SATURATIONS IN A ROW:{saturation_counter}', (20, 170), cv2.FONT_HERSHEY_SIMPLEX, 1, (0, 0, 255), 2)
                elif perclos<0:
                    #if negative i saturate to zero%
                    cv2.putText(image, f'PERCLOS: 0%', (20, 140), cv2.FONT_HERSHEY_SIMPLEX, 1, (0, 0, 255), 2)
                    if entrato==0:
                            saturation_counter+=1
                            entrato=1
                    cv2.putText(image, f'SATURATIONS IN A ROW:{saturation_counter}', (20, 170), cv2.FONT_HERSHEY_SIMPLEX, 1, (0, 0, 255), 2)
                
            else:
                cv2.putText(image, f'PERCLOS: NOT AVAILABLE YET!',(20, 140), cv2.FONT_HERSHEY_SIMPLEX, 1, (0, 0, 255), 2)

            #Ear less than 0.2 means that the driver is looking at the phone, so we want to detect that 
            if ear_m<0.22 and look_down_flag==0:
                start_look_down=time.time()
                look_down_flag=1
            if ear_m>=0.22:
                look_down_flag=0
            if ear_m<0.22 and look_down_flag==1 and time.time()-start_look_down>2.0 and drowsy==0:
                if FRAME_cnt%3!=0:
                    cv2.putText(image, f'!!!WARNING THE DRIVER IS DISTRACTED!!!', (2, 400), cv2.FONT_HERSHEY_SIMPLEX, 2, (0, 0, 255), 4)

            # EAR display
            cv2.putText(image, f'LEFT EAR : {ear_le:.4f}', (20, 80), cv2.FONT_HERSHEY_SIMPLEX, 1, (255, 0, 0), 2)
            cv2.putText(image, f'RIGHT EAR : {ear_re:.4f}', (20, 110), cv2.FONT_HERSHEY_SIMPLEX, 1, (255, 0, 0), 2)

        # 4.5 - Show the frame to the user

        cv2.imshow('Technologies for Autonomous Vehicles - Driver Monitoring Systems using AI code sample', image)

    if cv2.waitKey(5) & 0xFF == 27:
        break

# 5 - Close properly soruce and eventual log file
cap.release()

# log_file.close()
# [EOF]
