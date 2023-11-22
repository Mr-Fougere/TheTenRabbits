Rabbit.create(
    [{name: "Sparky", color: "brown"},
    {name: "Scotty", color: "pink"},
    {name: "Remmy", color: "grey"},
    {name: "Steevie", color: "purple"},
    {name: "Timmy", color: "black"},
    {name: "Debbie", color: "red"},
    {name: "Sergie", color: "blue"},
    {name: "Appie", color: "orange"},
    {name: "Ginny", color: "white"},
    {name: "Larry", color: "green"}])

Speech.create([
    {id:1,text:"introduction-1", rabbit_id: 1},
    {id:2,text:"introduction-2", rabbit_id: 1},
    {id:3,text:"introduction-3A", rabbit_id: 1},
    {id:4,text:"introduction-3B", rabbit_id: 1},
    {id:5,text:"introduction-4A-N", rabbit_id: 1},
    {id:6,text:"introduction-4-Y", rabbit_id: 1},
    {id:7,text:"introduction-4B-N", rabbit_id: 1},
    {id:8,text:"introduction-5", rabbit_id: 1},
    {id:9,text:"introduction-6", rabbit_id: 1},
    {id:10,text:"introduction-7", rabbit_id: 1},
])

SpeechBranch.create([
    {current_speech_id: 1, follow_speech_id: 2},
    {current_speech_id: 2, follow_speech_id: 3},
    {current_speech_id: 3, follow_speech_id: 5, answer: "no"},
    {current_speech_id: 3, follow_speech_id: 6, answer: "yes"},
    {current_speech_id: 4, follow_speech_id: 6, answer: "yes"},
    {current_speech_id: 4, follow_speech_id: 7, answer: "no"},
    {current_speech_id: 5, follow_speech_id: 4, speech_exited: true},
    {current_speech_id: 7, follow_speech_id: 4, speech_exited: true},
    {current_speech_id: 6, follow_speech_id: 8,},
    {current_speech_id: 9, follow_speech_id: 10}
])

Speech.create([
    {id:11,text:"hint-1", rabbit_id: 1, speech_type: "hint"},
    {id:12,text:"hint-ginny", rabbit_id: 1, speech_type: "hint", colored_words: ["drop","a","carrot"]},
    {id:13,text:"hint-remmy", rabbit_id: 1, speech_type: "hint", colored_words: ["doesn't","like","small","spaces"]},
    {id:14,text:"hint-debbie", rabbit_id: 1, speech_type: "hint", colored_words: ["console"]},
    {id:15,text:"hint-larry", rabbit_id: 1, speech_type: "hint", colored_words: ["understands","fives"]},
    {id:16,text:"hint-steevie", rabbit_id: 1, speech_type: "hint", colored_words: ["shout","this","name"]},
    {id:17,text:"hint-sergie", rabbit_id: 1, speech_type: "hint", colored_words: ["keep","right","path"]},
    {id:18,text:"hint-appie", rabbit_id: 1, speech_type: "hint",colored_words: ["Appie's","key","DOMain"]},
    {id:19,text:"hint-timmy", rabbit_id: 1, speech_type: "hint", colored_words: ["too","lighter"]},
    {id:20, text:"hint-no-thanks", rabbit_id: 1, speech_type: "hint"},
])

SpeechBranch.create([
    {current_speech_id: 11, follow_speech_id: 12, answer: "ginny"},
    {current_speech_id: 12, follow_speech_id: 11, speech_exited: true},
    {current_speech_id: 11, follow_speech_id: 13, answer: "remmy"},
    {current_speech_id: 13, follow_speech_id: 11, speech_exited: true},
    {current_speech_id: 11, follow_speech_id: 14, answer: "debbie"},
    {current_speech_id: 14, follow_speech_id: 11, speech_exited: true},
    {current_speech_id: 11, follow_speech_id: 15, answer: "larry"},
    {current_speech_id: 15, follow_speech_id: 11, speech_exited: true},
    {current_speech_id: 11, follow_speech_id: 16, answer: "steevie"},
    {current_speech_id: 16, follow_speech_id: 11, speech_exited: true},
    {current_speech_id: 11, follow_speech_id: 17, answer: "sergie"},
    {current_speech_id: 17, follow_speech_id: 11, speech_exited: true},
    {current_speech_id: 11, follow_speech_id: 18, answer: "appie"},
    {current_speech_id: 18, follow_speech_id: 11, speech_exited: true},
    {current_speech_id: 11, follow_speech_id: 19, answer: "timmy"},
    {current_speech_id: 19, follow_speech_id: 11, speech_exited: true},
    {current_speech_id: 11, follow_speech_id: 20, answer: "no_thanks"},
    {current_speech_id: 20, follow_speech_id: 11, speech_exited: true},
])

Speech.create([
    {id:21,text:"enigma-1A", rabbit_id: 10, speech_type: "enigma"},
    {id:22,text:"enigma-1B", rabbit_id: 10, speech_type: "enigma"},
    {id:23,text:"enigma-2-Y", rabbit_id: 10, speech_type: "enigma"},
    {id:24,text:"enigma-2-N", rabbit_id: 10, speech_type: "enigma"},
    {id:25,text:"enigma-2B-O", rabbit_id: 10, speech_type: "enigma"},
    {id:26,text:"enigma-2A-O", rabbit_id: 10, speech_type: "enigma"},
    {id:27,text:"enigma-3", rabbit_id: 10, speech_type: "enigma"},
    {id:28,text:"introduction-1", rabbit_id: 10},
])


SpeechBranch.create([
    {current_speech_id: 21, follow_speech_id: 23, answer: "yes"},
    {current_speech_id: 21, follow_speech_id: 24, answer: "no"},
    {current_speech_id: 21, follow_speech_id: 26},

    {current_speech_id: 22, follow_speech_id: 23, answer: "yes"},
    {current_speech_id: 22, follow_speech_id: 25, answer: "no"},
    {current_speech_id: 22, follow_speech_id: 26},
    
    {current_speech_id: 24, follow_speech_id: 22, speech_exited: true},
    {current_speech_id: 25, follow_speech_id: 22, speech_exited: true},
    {current_speech_id: 26, follow_speech_id: 22, speech_exited: true},

    {current_speech_id: 23, follow_speech_id: 27},
])

Speech.create([
    {id:29,text:"introduction-1", rabbit_id: 2},
    {id:30,text:"introduction-1", rabbit_id: 3},
    {id:31,text:"introduction-1", rabbit_id: 4},
    {id:32,text:"introduction-1", rabbit_id: 5},
    {id:33,text:"introduction-1", rabbit_id: 6},
    {id:34,text:"introduction-1", rabbit_id: 7},
    {id:35,text:"introduction-1", rabbit_id: 8},
    {id:36,text:"introduction-1", rabbit_id: 9}
])

Speech.create([
    {id:37,text:"random-1", rabbit_id: 2, speech_type: "random"},
    {id:38,text:"random-1", rabbit_id: 3, speech_type: "random"},
    {id:39,text:"random-1", rabbit_id: 4, speech_type: "random"},
    {id:40,text:"random-1", rabbit_id: 5, speech_type: "random"},
    {id:41,text:"random-1", rabbit_id: 6, speech_type: "random"},
    {id:42,text:"random-1", rabbit_id: 7, speech_type: "random"},
    {id:43,text:"random-1", rabbit_id: 8, speech_type: "random"},
    {id:44,text:"random-1", rabbit_id: 9, speech_type: "random"},
    {id:45,text:"random-1", rabbit_id: 10, speech_type: "random"},
])

Speech.create([
    {id:46,text:"found-larry", rabbit_id: 1, speech_type: "found"},
    {id:47,text:"found-remmy", rabbit_id: 1, speech_type: "found"},
    {id:48,text:"found-appie", rabbit_id: 1, speech_type: "found"},
    {id:49,text:"found-debbie", rabbit_id: 1, speech_type: "found"},
    {id:50,text:"found-steevie", rabbit_id: 1, speech_type: "found"},
    {id:51,text:"found-timmy", rabbit_id: 1, speech_type: "found"},
    {id:52,text:"found-sergie", rabbit_id: 1, speech_type: "found"},
    {id:53,text:"found-ginny", rabbit_id: 1, speech_type: "found"},
    {id:54,text:"found-all", rabbit_id: 1, speech_type: "found"}
])

SpeechBranch.create([
    {current_speech_id: 46, follow_speech_id: 11, speech_exited: true},
    {current_speech_id: 47, follow_speech_id: 11, speech_exited: true},
    {current_speech_id: 48, follow_speech_id: 11, speech_exited: true},
    {current_speech_id: 49, follow_speech_id: 11, speech_exited: true},
    {current_speech_id: 50, follow_speech_id: 11, speech_exited: true},
    {current_speech_id: 51, follow_speech_id: 11, speech_exited: true},
    {current_speech_id: 52, follow_speech_id: 11, speech_exited: true},
    {current_speech_id: 53, follow_speech_id: 11, speech_exited: true},
])



#Speech.create([
#   {id:21,text:"introduction-1A", rabbit_id: 10, speech_type: "introduction"},
#   {id:22,text:"introduction-1B", rabbit_id: 10, speech_type: "introduction"},
#   {id:23,text:"introduction-2-Y", rabbit_id: 10, speech_type: "introduction"},
#   {id:24,text:"introduction-2-N", rabbit_id: 10, speech_type: "introduction"},
#    {id:25,text:"introduction-2B-O", rabbit_id: 10, speech_type: "introduction"},
#    {id:26,text:"introduction-2A-O", rabbit_id: 10, speech_type: "introduction"},
#    {id:27,text:"introduction-3A", rabbit_id: 10, speech_type: "introduction"},
#    {id:28,text:"introduction-3B", rabbit_id: 10, speech_type: "introduction"},
#    {id:29,text:"introduction-4-Y", rabbit_id: 10, speech_type: "introduction"},
#    {id:30,text:"introduction-4-N", rabbit_id: 10, speech_type: "introduction"},
#    {id:31,text:"introduction-5", rabbit_id: 10, speech_type: "introduction"},
#    {id:32,text:"introduction-6-Y", rabbit_id: 10, speech_type: "introduction"},
#    {id:33,text:"introduction-6-N", rabbit_id: 10, speech_type: "introduction"},
#    {id:34,text:"introduction-6-O", rabbit_id: 10, speech_type: "introduction"},
#    {id:35,text:"introduction-7", rabbit_id: 10, speech_type: "introduction"}
#])
#
#SpeechBranch.create([
#    {current_speech_id: 21, follow_speech_id: 23, answer: "yes"},
#    {current_speech_id: 21, follow_speech_id: 24, answer: "no"},
#    {current_speech_id: 21, follow_speech_id: 26},
#
#    {current_speech_id: 22, follow_speech_id: 23, answer: "yes"},
#    {current_speech_id: 22, follow_speech_id: 25, answer: "no"},
#    {current_speech_id: 22, follow_speech_id: 26},
#    
#    {current_speech_id: 24, follow_speech_id: 21, speech_exited: true},
#    {current_speech_id: 25, follow_speech_id: 22, speech_exited: true},
#    {current_speech_id: 26, follow_speech_id: 22, speech_exited: true},
#
#    {current_speech_id: 23, follow_speech_id: 27},
#
#    {current_speech_id: 27, follow_speech_id: 29, answer: "ten"},
#    {current_speech_id: 27, follow_speech_id: 29, answer: "10"},
#    {current_speech_id: 27, follow_speech_id: 30},
#
#    {current_speech_id: 28, follow_speech_id: 29, answer: "ten"},
#    {current_speech_id: 28, follow_speech_id: 29, answer: "10"},
#    {current_speech_id: 28, follow_speech_id: 30},
#
#    
#    {current_speech_id: 30, follow_speech_id: 28, speech_exited: true},   
#     
#    {current_speech_id: 29, follow_speech_id: 31},
#    
#    {current_speech_id: 31, follow_speech_id: 32, answer: "bros"},
#    {current_speech_id: 31, follow_speech_id: 32, answer: "bro"},
#    {current_speech_id: 31, follow_speech_id: 33, answer: "sis"},
#    {current_speech_id: 31, follow_speech_id: 34},
#
#    {current_speech_id: 34, follow_speech_id: 31, speech_exited: true},   
#    {current_speech_id: 33, follow_speech_id: 31, speech_exited: true},   
#
#    {current_speech_id: 32, follow_speech_id: 35}
#
#])
#


