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
                        Text("Home").font(.title).bold().offset(CGSize(width: 0, height: 16))
                    }
                    .listRowSeparator(.hidden)
                    ForEach(viewModel.homeCollections, id: \.type) { collection in
                        Section(
                            header: Text(collection.title)
                            .font(.title2)
                            .backgroundStyle(.white)
                        ) {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 20) {
                                    ForEach(collection.stories) { story in
                                        StoryView(story: story)
                                    }
                                }
                                .padding(.horizontal)
                            }
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
                    leading: Button {
                    } label: {
                        Image("bududu-min")
                            .resizable()
                            .frame(width: 60, height: 60)
                            .cornerRadius(30)
                            .overlay(
                                Circle().stroke(Color(hex: "#33333"), lineWidth: 1.5)
                            )
                    }.offset(CGSize(width: 8, height: 8)),
                    trailing: HStack {
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
                )
                .onAppear {
                    viewModel.fetchHomeCollections()
                }
            }
            if let error = viewModel.error {
                VStack {
                    ToastView(type: .error, message: "\(error.message)")
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                                viewModel.error = nil
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
            Image(story.imageURL)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 120, height: 120)
            Text(story.title)
                .font(.headline)
                .lineLimit(1)
            Text(story.subTitle)
                .font(.subheadline)
                .foregroundColor(.gray)
                .lineLimit(1)
        }
        .frame(width: 120)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
