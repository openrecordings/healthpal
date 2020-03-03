# Tags and Links for Linda are still in this file because they are all mixed together with Chris's
desc "Load Chris's tags and links for usability testing"
task chris_tags_and_links: :environment do
  id_offset = 3279
  r = Recording.find(8)
  utts = utterances.delete_if {|u| u[0].round(-3) < 3000}
  loadtags(r, utts)
  loadlinks(r, utts)
end

def loadtags(r, utts)
  # the min id for utterance records in r
  min_u_id = r.utterances.select(:id).min_by {|u| u.id}.id
  # the min id in the utterances array for utts
  umin_id = utts.min_by {|u| u[0]}[0]
  utts.each_with_index do |ut, i|
    utags = tags.find_all {|t| t[0] == umin_id + i}
    if utags
      puts utags.count
      utt = Utterance.find(min_u_id + i)
      utags.each do |t|
        puts t
        tag.create!(
          utterance: utterance.find(min_u_id + i),
          tag_type: tagtype.find(t[1])
        )
      end
    end
  end
end

def loadlinks(r, utts)
  # the min id for utterance records in r
  min_u_id = r.utterances.select(:id).min_by {|u| u.id}.id
  # the min id in the utterances array for utts
  umin_id = utts.min_by {|u| u[0]}[0]
  utts.each_with_index do |ut, i|
    ulinks = links.find_all {|l| l[3] == umin_id + i}
    if ulinks
      utt = Utterance.find(min_u_id + i)
      ulinks.each do |l|
        Link.create!(
          utterance: Utterance.find(min_u_id + i),
          label: l[1],
          url: l[2]
        )
      end
    end
  end
end

def utterances
  # id, text, start_time, end_time],
  [
    [3279,"So, I read your thing.  So let's, what's going with this first of all?",0,5],
    [3280,"I have no idea. Umm, it's feeling a little bit better today but it, it started off Sunday, just scratchy throat, then it turned into a bunch of drainage and constantly clearing my throat and then I got all congested up in here.  And now, it has just been really dry and still scratchy.",5,20],
    [3281,"Do you get allergies in the spring typically?",20,22],
    [3282,"No, but the allergist just -  I just went back and got my results from my lab work and he says I'm -",22,27],
    [3283,"Who says?",27,28],
    [3284,"He sent me to Osmond.",28,29],
    [3285,"Okay, okay.  Yes.",29,30],
    [3286,"_____ yeah and then it ended up doing an allergy test and said that I'm highly allergic to - dust, and then grass and ragweed were other ones that were high.  He did say -",30,42],
    [3287,"Mold is a pretty big one this time of the year.",42,44],
    [3288,"Yeah, because of all the snow -",44,46],
    [3289,"Yup.  Those tests are not what I recall scientifically awesome yet?",46,50],
    [3290,"Yeah.",50,52],
    [3291,"Yeah.  There was also this thing called provocative desensitization where it's like a whole different test you give, but, I was just kind of wondering if typically when the snow goes, if you get more of this?  So, that can be -",52,66],
    [3292,"Uhm, when like the weather changes.  I mean, I know a lot of people that are complaining of similar things -",66,72],
    [3293,"Um-hum. Flonase.  You got -",72,74],
    [3294,"Yeah.  Flonase -",74,76],
    [3295,"You can double up on that for a little while if it doesn't dry you out too much, okay?",76,80],
    [3296,"Okay.",80,81],
    [3297,"- you can increase the Flonase for a little while and see if that helps at least.  The other big thing you can use to kind of differentiate between is it more of an allergy thing or some type of an upper respiratory infection is your temperature.  So, if your temp's going up, it's probably more than just allergy.",81,95],
    [3298,"Well, I haven't kinda paid attention to that.  So far, I haven't had a temp, so far.",95,101],
    [3299,"Okay.  all right, so what else have we got here?",101,103],
    [3300,"Uhm.  I have the, I would say -",103,105],
    [3301,"The stomachy stuff.",105,106],
    [3302,"Yeah.",106,107],
    [3303,"So did you go to the higher doses of the omeprazole that we talked about?",107,111],
    [3304,"I didn't.  I, uhm.",111,112],
    [3305,"Okay.",112,114],
    [3306,"How is this all feeling?",114,115],
    [3307,"It's, ahh.  There are some days it's feeling a little better, like today.  Uhm, and another times, it just starts acting up again and the Pepto-Bismol, I tried that.",115,125],
    [3308,"Yeah.",125,126],
    [3309,"I was too worried about the Carafate after reading about the Carafate, so I tried the Pepto-Bismol and that seemed to - it kind of seemed to help -there was a note, I noticed it at least.",126,137],
    [3310,"Okay.",137,139],
    [3311,"Uhm.",139,141],
    [3312,"So, I'll say Pepto helped.  So, are you taking any of the omeprazole now?",141,146],
    [3313,"No.",146,147],
    [3314,"So, you stopped taking that entirely?",147,150],
    [3315,"Oh, wait.  No, omeprazole.  Yes.",150,155],
    [3316,"Yes.",155,156],
    [3317,"I was thinking Carafate.  I'm sorry.",156,159],
    [3318,"That's okay.  So the omeprazole you're taking 20?",159,162],
    [3319,"Yeah, if I took them.",162,164],
    [3320,"Okay.",164,165],
    [3321,"I haven't taken it today, but I took them yesterday.",165,168],
    [3322,"Okay.  So I'd say - ""Has been taking 20 mg of omeprazole.""",168,173],
    [3323,"And when I take that, as you know, but I'm worried about my heart.",173,177],
    [3324,"I know.  But, so worrying is a sensation that you're gonna have to keep on trusting that it's not in itself bad, so that worrying can kinda come and go just like the bad weather can come and go, but if you give it too much power, then it can help you stay in these loops that you just don't wanna stay in.",177,195],
    [3325,"I talked to, probably, 5 different people about my stomach systems and my bloating and all that stuff -",195,201],
    [3326,"Yeah.",201,202],
    [3327,"-'cause I do, I still have that happen and they are all like, ""It's gallbladder.  It is gallbladder.""  And so, I had my gallbladder removed.  That's exactly what it is.  Like you need to tell your doctor to check your gallbladder and I, I said, well I'm going in there and I looked online and some of the symptoms sounded about right, but I mean, I don't have pain in the right part of my back.",202,223],
    [3328,"But you, you don't always guess.  So you don't always get all of the above, but you had been?",223,229],
    [3329,"They told, when I went to the ER -",229,232],
    [3330,"Yeah.",232,233],
    [3331,"-for my stomach and they said I was constipated.  I don't know what labs he ran on, while in the ED, they said that your doctor can just run a CBC and a liver enzyme.",233,244],
    [3332,"BMP is gonna cover it.",244,246],
    [3333,"Yes, BMP will show liver enzymes.",246,249],
    [3334,"Yup.  It will show alk phos.  It will show uhm AST and ALT, which I'm pretty sure they had already done a while ago.",249,257],
    [3335,"Oh, my stomach had, that's about right when my stomach was really bothering me the most is when I went to the ER for it.",257,264],
    [3336,"So, this is interesting.  I logged for March 26, that's when you're in the emergency room I think, isn't this?",264,270],
    [3337,"Uh-hmm.  When I went in March, it's when the stomach pain has been going on for a little while now.",270,277],
    [3338,"Yeah.  So, your AST, ALT, alk phos were all normal.  So, that's good.  I - I - had looked at those when you initially had gone out, but I couldn't remember.",277,288],
    [3339,"Right.",288,289],
    [3340,"Okay, anything else for now that we need to think about?  I gotta check you over.",289,293],
    [3341,"Quick, I mentioned in the email, I don't know what's going on.",293,296],
    [3342,"Oh, that popping sound?",296,298],
    [3343,"I got, it's like gurgling, it's a carbonated water in the base of my head I can feel it here.",298,304],
    [3344,"When you move around?",304,305],
    [3345,"No.  Not still or when I move around - but the past couple of days, it's been happening frequently, and especially in the morning when I first got up, and I can feel the little bubbles like in the back of my spine.",305,317],
    [3346,"Like if you're totally stationary, do you notice this?",317,319],
    [3347,"Yeah.",319,321],
    [3348,"So, even if you didn't move about?",321,323],
    [3349,"Not constantly.",323,325],
    [3350,"I know, but try to pay attention and see if it happens around movement times.",325,328],
    [3351,"It's the bubbling and it's that part, why, why would that happen and what, why all of a sudden?",328,336],
    [3352,"I'm well, again, I'm not saying 100%, but since you got a bunch of upper respiratory stuff, it's probably because of that.",336,342],
    [3353,"Okay.",342,344],
    [3354,"Now, let me listen to your heart.  That sounds good, nice and regular.  I don't hear any jump beats.  Take breaths in and out.",344,355],
    [3355,"Good.  Your lungs sound nice and clear.  all right my man, let's get together in 3 to 4 weeks.  What do you think?  Four weeks sound good on your end?  And you see Cardiology.  No, you're gonna see GI.",355,367],
    [3356,"I'm seeing GI.",367,368],
    [3357,"Next week.",368,369],
    [3358,"Can you, just real quick -",369,371],
    [3359,"Yeah.",371,372],
    [3360,"Uhm feel my belly.",372,373],
    [3361,"Yeah.",373,374],
    [3362,"It does still bother me, it's ah..",374,377],
    [3363,"I was thinking about it when I was listening to your lungs, but I though ­­-",377,381],
    [3364,"I fell, like twice now.",381,383],
    [3365,"Yeah.  It sounds pretty good.  When did you eat last roughly?",383,386],
    [3366,"Uh-hmm, about 45 minutes ago.",386,389],
    [3367,"My hands are buried, but it's just hand, but I'm not feeling anything that makes me worried.",389,394],
    [3368,"Okay.",394,395],
    [3369,"And I think that, I think you probably have gastritis.  It will probably come and go again.  I mean, it's with the laryngitis that you had GI stuff and that's what _____ right as well.  So, really, really embrace those body goals.",395,410],
    [3370,"Okay.",410,411],
    [3371,"all right, bye then.",411,413],
    [3372,"all right, thanks.",413,414],
    [3373,"You're welcome.",414,415],
    [3374,"Okay.",415,416],
  ]
end

def tags
  # utterance_id, tag_type_id
  [
    [4216,6],
    [4222,2],
    [4235,5],
    [4245,6],
    [4252,2],
    [4290,3],
    [4300,8],
    [4346,5],
    [4354,5],
    [4360,8],
    [3280,6],
    [3282,7],
    [3291,3],
    [3293,2],
    [3297,3],
    [3303,2],
    [3307,2],
    [3307,6],
    [3323,6],
    [3324,5],
    [3325,6],
    [3332,3],
    [3338,7],
    [3342,6],
    [3350,5],
    [3352,3],
    [3354,7],
    [3355,4],
    [3360,6],
    [3369,3],
    [3369,5],
    [4223,2],
    [4225,2],
    [4226,2],
    [4229,7],
    [4230,6],
    [4237,5],
    [4239,5],
    [4239,7],
    [4251,6],
    [4252,3],
    [4257,6],
    [4257,2],
    [4262,3],
    [4264,3],
    [4265,6],
    [4266,2],
    [4270,2],
    [4270,6],
    [4282,1],
    [4290,1],
    [4306,8],
    [4317,5],
    [4319,3],
    [4330,1],
    [4332,3],
    [4333,6],
    [4364,5],
    [4376,8],
    [4382,8],
    [4392,8],
    [4410,5],
    [4414,5],
    [3285,2]
  ]
end

def links
  [[
  '0:09',
  'Norco ',
  'https://medlineplus.gov/druginfo/meds/a601006.html',
  4222
  ],[
  '0:14',
  'Gabapentin',
  'https://medlineplus.gov/druginfo/meds/a694007.html',
  4222
  ],[
  '0:17',
  'Tramadol',
  'https://medlineplus.gov/druginfo/meds/a695011.html',
  4222
  ],[
  '0:27',
  'high blood pressure',
  'https://medlineplus.gov/highbloodpressure.html',
  4229
  ],[
  '1:41',
  'Gabapentin',
  'https://medlineplus.gov/druginfo/meds/a694007.html',
  4252
  ],[
  '1:41',
  'shingles',
  'https://medlineplus.gov/shingles.html',
  4252
  ],[
  '1:54',
  'Gabapentin',
  'https://medlineplus.gov/druginfo/meds/a694007.html',
  ],[
  '1:41',
  'Gabapentin',
  'https://medlineplus.gov/druginfo/meds/a694007.html',
  ],[
  '2:04',
  'Gabapentin',
  'https://medlineplus.gov/druginfo/meds/a694007.html',
  4257
  ],[
  '2:29',
  'Gabapentin',
  'https://medlineplus.gov/druginfo/meds/a694007.html',
  4262
  ],[
  '2:40',
  'Gabapentin',
  'https://medlineplus.gov/druginfo/meds/a694007.html',
  4266
  ],[
  '3:00',
  'foot pain',
  'https://medlineplus.gov/ency/article/003183.htm',
  4270
  ],[
  '3:22',
  'bunion',
  'https://medlineplus.gov/ency/article/001231.htm',
  4270
  ],[
  '3:26',
  'arthritis',
  'https://medlineplus.gov/arthritis.html',
  4270
  ],[
  '3:44',
  'arthritis',
  'https://medlineplus.gov/arthritis.html',
  4282
  ],[
  '4:03',
  'ganglion cyst',
  'https://www.assh.org/handcare/hand-arm-conditions/ganglion-cyst',
  4290
  ],[
  '5:20',
  'ganglion cyst',
  'https://www.assh.org/handcare/hand-arm-conditions/ganglion-cyst',
  4317
  ],[
  '5:59',
  'ganglion cyst',
  'https://www.assh.org/handcare/hand-arm-conditions/ganglion-cyst',
  4330
  ],[
  '6:57',
  'blood count test',
  'https://medlineplus.gov/bloodcounttests.html',
  4346
  ],[
  '7:14',
  'pain management',
  'http://www.asahq.org/whensecondscount/pain-management/',
  4360
  ],[
  '7:30',
  'pain management',
  'http://www.asahq.org/whensecondscount/pain-management/',
  4364
  ],[
  '10:11',
  'blood pressure measurement',
  'https://medlineplus.gov/ency/article/007490.htm',
  4410
  ]]
end
