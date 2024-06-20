//
//  ContentView.swift
//  Glossika-Assignment
//
//  Created by Bomi Chen on 2024/6/19.
//

import SwiftUI

struct HomeView: View {
    
    @StateObject private var viewModel = HomeViewModel()
    
    var body: some View {
        GeometryReader { geometry in
            NavigationStack {
                Spacer().frame(height: 24)
                List {
                    Section {
                        Text("Home").font(.title).bold()
                    }
                    .listRowSeparator(.hidden)
                    ForEach(viewModel.homeCollections, id: \.type) { collection in
                        Section(
                            header: Text(collection.title)
                                .font(.title2)
                                .backgroundStyle(.white)
                                .padding(.bottom, 4)
                        ) {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(alignment: .top, spacing: 20) {
                                    ForEach(collection.stories) { story in
                                        StoryView(story: story)
                                    }
                                }
                                .padding(.horizontal)
                            }
                            .offset(CGSize(width: -8, height: 0))
                        }
                        .listRowSeparator(.hidden)
                    }
                    HStack {
                        Spacer().frame(height: 16)
                        Image(systemName: "lasso")
                            .foregroundColor(Color.black.opacity(0.3))
                            .frame(width: 50, height: 50)
                            .aspectRatio(contentMode: .fill)
                        Spacer().frame(height: 0)
                    }
                    .listRowSeparator(.hidden)
                }
                .listStyle(.plain)
                .background(Color.white)
                .navigationBarItems(
                    leading:
                        HStack {
                            Button {
                            } label: {
                                Image(systemName: "square.stack.3d.down.forward.fill")
                                    .foregroundColor(Color.black.opacity(0.72))
                            }
                            Button {
                            } label: {
                                Image(systemName: "play.square.stack")
                                    .foregroundColor(Color.black.opacity(0.72))
                            }
                        }
                        .offset(CGSize(width: 0, height: 16))
                    , trailing:
                        Button {
                            
                        } label: {
                            Image("bududu-min")
                                .resizable()
                                .frame(width: 50, height: 50)
                                .cornerRadius(25)
                        }
                        .offset(CGSize(width: -8, height: 8))
                )
                .onAppear {
                    viewModel.fetchHomeCollections()
                }
            }
            if let error = viewModel.error {
                HStack {
                    Spacer()
                    VStack {
                        ToastView(type: .error, message: error.message)
                            .onAppear {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                                    viewModel.error = nil
                                }
                            }
                    }
                    Spacer()
                }
            }
        }
    }
}

struct StoryView: View {
    var story: Story
    
    var body: some View {
        VStack(alignment: .leading) {
            if let url = URL(string: story.thumbnailUrl) {
                WebImageView(url: url)
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 120, height: 120)
                    .clipped()
                    .foregroundColor(Color(white: 0.97))
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 120, height: 120)
                    .clipped()
                    .foregroundColor(Color(white: 0.97))
            }
            Text(story.title)
                .font(.headline)
                .lineLimit(1)
            Text(story.subTitle)
                .font(.subheadline)
                .foregroundColor(Color.hex("aeafb3"))
                .lineLimit(3)
        }
        .frame(width: 120, alignment: .topLeading)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
