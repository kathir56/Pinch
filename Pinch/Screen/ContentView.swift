//
//  ContentView.swift
//  Pinch
//
//  Created by Kathiravan Murali on 23/12/23.
//

import SwiftUI

struct ContentView: View {
    @State private var isAnimating : Bool = false
    @State private var imageScale : CGFloat = 1
    @State private var imageOffset : CGSize = .zero
    @State private var drawerOpen : Bool = false
    let pages : [Page] = pagesData
    @State private var pageIndex : Int = 0
    var body: some View {
        NavigationView
        {
            ZStack
            {
                Color.clear // to show that SF symbol on top
                Image(pages[pageIndex].name)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(10)
                    .padding()
                    .shadow(color: .black.opacity(0.8), radius: 12, x: 2,y: 2)
                    .offset(x: imageOffset.width, y: imageOffset.height)
                    .scaleEffect(imageScale)
                    .opacity(isAnimating ? 1 : 0)
                    .onTapGesture(count: 2, perform: {
                        if imageScale == 1
                        {
                            withAnimation(.spring())
                            {
                                imageScale = 5
                            }
                        }
                        else
                        {
                            withAnimation()
                            {
                                imageScale = 1
                                imageOffset = .zero
                            }
                        }
                    })
                    .gesture(
                        DragGesture()
                            .onChanged{ value in
                                withAnimation(.linear(duration: 1))
                                {
                                    imageOffset = value.translation
                                }
                            }
                            .onEnded{_ in
                                withAnimation(.smooth)
                                {
                                    if imageScale <= 1
                                    {
                                        imageScale = 1
                                        imageOffset = .zero
                                    
                                    }
                                }
                            }
                    )
                    .gesture(
                        MagnificationGesture()
                            .onChanged{ value in
                                imageScale = value
                            }
                    )
                
                
            }
            .navigationTitle("Pinch & Zoom")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear(perform: {
                withAnimation(.interpolatingSpring(duration: 2))
                {
                    isAnimating.toggle()
                }
                
            })
            .overlay(InfoView(scale: imageScale, offset: imageOffset)
                .padding(.horizontal)
                .padding(.top,30)
                , alignment : .top)
            .overlay(
                Group
                {
                    HStack
                    {
                        Button {
                            withAnimation(.spring())
                            {
                                if imageScale>1
                                {
                                    imageScale-=1
                                }
                                else
                                {
                                    imageOffset = .zero
                                }
                                                            }
                            
                            
                        } label: {
                            Image(systemName: "minus.magnifyingglass")
                                .font(.system(size: 20))
                        }
                        
                        Button {
                            
                            withAnimation(.spring())
                            {
                                imageScale = 1
                                imageOffset = .zero
                            }
                            
                            
                            
                        } label: {
                            Image(systemName: "arrow.up.left.and.down.right.magnifyingglass")
                                .font(.system(size: 20))
                        }
                        
                        Button {
                            withAnimation(.spring())
                            {
                                imageScale+=1
                            }
                            
                        } label: {
                            Image(systemName: "plus.magnifyingglass")
                                .font(.system(size: 20))
                        }

                    }
                    .padding(EdgeInsets(top: 12, leading: 20, bottom: 12, trailing: 20))
                    .background(.ultraThinMaterial)
                    .cornerRadius(20)
                    .opacity(isAnimating ? 1 : 0)
                }
                .padding(.bottom,30)
                , alignment : .bottom
            )
            .overlay(
                HStack(spacing: 12) {
                    Image(systemName: drawerOpen ? "chevron.compact.right" : "chevron.compact.left")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 40)
                        .padding(8)
                        .foregroundStyle(.secondary)
                        .onTapGesture {
                            withAnimation(.easeOut)
                            {
                                drawerOpen.toggle()
                            }
                            
                        }
                    ForEach(pages) { page in
                        Image(page.thumbnail)
                            .resizable()
                            .scaledToFit()
                            .frame(width:80)
                            .cornerRadius(10)
                            .shadow(radius: 8)
                            .opacity(isAnimating ? 1 : 0)
                            .animation(.easeOut(duration: 0.5), value: drawerOpen)
                            .onTapGesture {
                                isAnimating = true
                                pageIndex = page.id
                            }
                    }
                    
                    Spacer()
                }
                    .padding(EdgeInsets(top: 16, leading: 8, bottom: 16, trailing: 8))
                    .background(.ultraThinMaterial)
                    .cornerRadius(12)
                    .opacity(isAnimating ? 1 : 0)
                    .frame(width: 260)
                    .padding(.top, UIScreen.main.bounds.height / 12)
                    .offset(x: drawerOpen ? 20 : 215)
                , alignment : .topTrailing
            )
            }
        .navigationViewStyle(.stack)
    }
}

#Preview {
    ContentView()
        .preferredColorScheme(.light)
}
