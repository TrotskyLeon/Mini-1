//
//  OnboardView.swift
//  Mini1
//
//  Created by Leo Harnadi on 29/04/23.
//

import SwiftUI
import LottieUI

struct OnboardView: View {
    @State private var currentPageIndex: Int = 0
    @Binding var name: String
    @Binding var time: Date
    @ObservedObject var entryViewModel: EntryViewModel
    
    @StateObject var EKManager: EventKitManager = EventKitManager()
    @ObservedObject var profileViewModel = ProfileViewModel()
    
    @Binding var isOnboardingCompleted: Bool
    
    let paleBlue = Color(UIColor(named: "paleBlue")!)
    
    var body: some View {
        ZStack {
            Color("paleBlue")
            
            VStack {
                if currentPageIndex == 0 {
                    HelloScreenView()
                } else if currentPageIndex == 1 {
                    Form1View(name: $name)
                        .transition(.asymmetric(insertion: .move(edge: .leading), removal: .move(edge: .leading)))
                } else if currentPageIndex == 2 {
                    Form2View(time: $time, name: $name)
                        .transition(.asymmetric(insertion: .opacity, removal: .opacity))
                }
                
                Spacer()
                
                HStack {
                    if currentPageIndex == 0 {
                        HStack {
                            Button(action: {
                                withAnimation() {
                                    currentPageIndex += 1
                                }
                            }, label: {
                                Text("Continue")
                                    .font(.system(size: 21))
                                    .foregroundColor(Color("paleBlue"))
                                    .frame(width: 210, height: 55)
                                    .background(Color.white)
                                    .cornerRadius(70)
                                    .padding(.trailing, 90)
                                    .background(Color("paleBlue"))
                            })
                        }
                    }

                    Spacer()
                    
                    if currentPageIndex == 1 {
                        HStack {
                            Button(action: {
                                withAnimation() {
                                    currentPageIndex -= 1
                                }
                            }) {
                                Image(systemName: "chevron.left")
                                    .font(.title)
                                    .foregroundColor(.white)
                            }
                            .padding(.top, -700)
                            .padding(.leading, 30)
                            Spacer()
                        }
                        HStack {
                            Button(action: {
                                withAnimation() {
                                    currentPageIndex += 1
                                }
                            }, label: {
                                Text("Continue")
                                    .font(.system(size: 21))
                                    .foregroundColor(profileViewModel.nameIsEmpty(name: name) ? Color.white : Color("paleBlue"))
                                    .frame(width: 210, height: 55)
                                    .background(profileViewModel.nameIsEmpty(name: name) ? Color.gray : Color.white)
                                    .cornerRadius(70)
                                    .padding(.trailing, 90)
                                    .background(Color("paleBlue"))
                            })
                            .disabled(profileViewModel.nameIsEmpty(name: name))
                        }
                    }

                    Spacer()
                    
                    if currentPageIndex == 2 {
                        Button(action: {
                            withAnimation() {
                                currentPageIndex += 1
                            }
                        }, label: {
                            Text("Continue")
                                .font(.system(size: 21))
                                .foregroundColor(profileViewModel.nameIsEmpty(name: name) ? Color.white : Color("paleBlue"))
                                .frame(width: 210, height: 55)
                                .background(profileViewModel.nameIsEmpty(name: name) ? Color.gray : Color.white)
                                .cornerRadius(70)
                                .padding(.trailing, 90)
                                .background(Color("paleBlue"))
                        })
                        .disabled(profileViewModel.nameIsEmpty(name: name))
                    } else {
                        Button(action: {
                            withAnimation() {
                                EKManager.addReminder(hour: Calendar.current.component(.hour, from: time), minute: Calendar.current.component(.minute, from: time))
                                
                                if !EKManager.emptyReminderList {
                                    entryViewModel.saveToChild(entry: entryViewModel.child[0], name: name, bedTime: time)
                                    entryViewModel.completeOnboarding(entry: entryViewModel.progress[0])
                                    
                                    isOnboardingCompleted = true
                                }
                            }) {
                                Image(systemName: "chevron.left")
                                    .font(.title)
                                    .foregroundColor(.white)
                            }
                            .padding(.top, -700)
                            .padding(.leading, 30)
                            Spacer()
                        }
                        HStack {
                            Button(action: {
                                withAnimation() {
                                    EKManager.addReminder(hour: Calendar.current.component(.hour, from: time), minute: Calendar.current.component(.minute, from: time))
                                    
                                    if !EKManager.emptyReminderList {
                                        isOnboardingCompleted = true
                                    }
                                }
                            }, label: {
                                Text("Save")
                                    .font(.system(size: 21))
                                    .foregroundColor(Color("paleBlue"))
                                    .frame(width: 210, height: 55)
                                    .background(Color.white)
                                    .cornerRadius(70)
                                    .padding(.bottom, 13)
                                    .padding(.trailing, 75)
                            })
                            .padding()
                        }
                    }
                }
            }
        }
        .onAppear(){
            EKManager.requestAccess()
        }
        .alert(isPresented: $EKManager.emptyReminderList) {
            Alert(
                title: Text("No Reminder List Found"),
                message: Text("Please create a list in your Reminders app."),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}

struct HelloScreenView: View {
    let paleBlue = Color(UIColor(named: "paleBlue")!)
    
    var body: some View {
        ZStack {
            Color("paleBlue").ignoresSafeArea()
            
            VStack {
                LottieView(state: LUStateData(type: .name("satu", .main), loopMode: .loop))
                    .scaleEffect(0.5)
            }
        }
    }
}

struct Form1View: View {
    @Binding var name: String
    @State private var showForm2View = false
    let paleBlue = Color(UIColor(named: "paleBlue")!)
    
    var body: some View {
        ZStack {
            paleBlue.edgesIgnoringSafeArea(.all)
            VStack{
                LottieView(state: LUStateData(type: .name("dua", .main), loopMode: .loop))
                    .scaleEffect(0.5)
                Text("Welcome!")
                    .font(.system(size: 32))
                    .foregroundColor(.white)
                    .padding(.top)
                Text("What's the name of your little one?")
                    .frame(width: 177, height: 55)
                    .font(.system(size: 21))
                    .padding(.top, 30)
                    .padding(.bottom, 65)
                    .foregroundColor(.white)
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.white)
                    .frame(width: 305, height: 45)
                    .overlay(
                        TextField("Your Baby's Name", text: $name)
                            .font(.system(size: 18))
                            .foregroundColor(.black)
                            .padding()
                    )
            }
        }
    }
}

struct Form2View: View {
    @Binding var time: Date
    @Binding var name: String
    
    let paleBlue = Color(UIColor(named: "paleBlue")!)
    
    var body: some View {
        ZStack{
            paleBlue.edgesIgnoringSafeArea(.all)
            VStack {
                LottieView(state: LUStateData(type: .name("tiga", .main), loopMode: .loop))
                    .scaleEffect(0.5)
                Text("Welcome!")
                    .font(.system(size: 32))
                    .foregroundColor(.white)
                    .padding(.top)
                if name.isEmpty {
                    Text("What time does your baby sleep?")
                        .multilineTextAlignment(.center)
                        .frame(width: 300, height: 100)
                        .font(.system(size: 21))
                        .padding(.top, 20)
                        .padding(.bottom, 65)
                        .foregroundColor(.white)
                } else {
                    Text("What time does \(name) sleep?")
                        .multilineTextAlignment(.center)
                        .frame(width: 260, height: 150)
                        .font(.system(size: 21))
                        .padding(.top, -20)
                        .padding(.bottom, 45)
                        .foregroundColor(.white)
                }
                ZStack {
                    Color("paleBlue")
                    DatePicker("", selection: $time, displayedComponents: .hourAndMinute)
                        .datePickerStyle(WheelDatePickerStyle())
                        .labelsHidden()
                        .frame(width: 299, height: 210)
                        .background(Color.white)
                    .cornerRadius(20)
                }
                .padding(.top, -100)
            }
        }
    }
}
