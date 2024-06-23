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
                Spacer().frame(height: 16)
                List {
                    if viewModel.layoutType == .grid {
                        Section {
                            Text("Home").font(.title).bold()
                        }
                        .listRowSeparator(.hidden)
                    }
                    ForEach(viewModel.homeCollections, id: \.type) { collection in
                        Section(
                            header:
                                ZStack(alignment: .leading) {
                                    HStack(alignment: .top) {
                                        Text(collection.title)
                                            .font(.title2)
                                            .foregroundColor(.hex("454545"))
                                            .backgroundStyle(.white)
                                    }
                                    if (viewModel.layoutType == .grid && collection.type != .recent) {
                                        HStack {
                                            Spacer()
                                            Image(systemName:  "chevron.right")
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: 8)
                                                .foregroundColor(.black.opacity(0.7))
                                                .padding(.horizontal, 4)
                                                .shadow(color: Color.gray.opacity(0.35), radius: 2, x: 2, y: 2)
                                        }
                                        
                                    }
                                }
                                .onTapGesture {
                                    if (viewModel.layoutType == .grid && collection.type != .recent) {
                                        viewModel.warning = "Coming Soon..."
                                    }
                                }
                            ,
                            footer:
                                viewModel.layoutType == .video ? AnyView(HStack {
                                    Spacer()
                                    Image(systemName: "scribble.variable")
                                        .foregroundColor(Color.black.opacity(0.35))
                                    Spacer()
                                }) : AnyView(EmptyView())
                        ) {
                            switch viewModel.layoutType {
                            case .grid:
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(alignment: .top, spacing: 20) {
                                        ForEach(collection.stories) { story in
                                            StoryView(story: story)
                                        }
                                    }
                                    .padding(.horizontal)
                                }
                                .offset(CGSize(width: -8, height: 0))
                            case .video:
                                ForEach(collection.stories) { story in
                                    VideoView(story: story)
                                        .listRowInsets(EdgeInsets()) // 移除邊距
                                        .padding(.top, 8)
                                        .listRowBackground(Color.clear)
                                        .clipped()
                                }
                            }
                        }
                        .listRowSeparator(.hidden)
                    }
                    if viewModel.layoutType == .grid {
                        HStack {
                            Spacer().frame(height: 16)
                            Image(systemName: "scribble.variable")
                                .foregroundColor(Color.black.opacity(0.35))
                                .frame(width: 50, height: 50)
                                .aspectRatio(contentMode: .fill)
                            Spacer().frame(height: 0)
                        }
                        .listRowSeparator(.hidden)
                    }
                }
                .refreshable {
                    viewModel.fetchHomeCollections()
                }
                .listStyle(.plain)
                .background(Color.white)
                .navigationBarItems(
                    leading:
                        HStack {
                            Button {
                                viewModel.layoutType = .grid
                            } label: {
                                Image(systemName: "square.stack.3d.down.forward.fill")
                                    .foregroundColor(viewModel.layoutType == .grid ? Color.black.opacity(0.72) : Color.gray.opacity(0.5))
                            }
                            Button {
                                viewModel.layoutType = .video
                            } label: {
                                Image(systemName: "play.square.stack")
                                    .foregroundColor(viewModel.layoutType == .video ? Color.black.opacity(0.72) : Color.gray.opacity(0.5))
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
                    if self.viewModel.layoutType == .grid {
                        viewModel.fetchHomeCollections()
                    }
                }
            }
            if let error = viewModel.error {
                HStack {
                    Spacer()
                    VStack {
                        ToastView(type: .error, message: error.message)
                            .padding(.top)
                            .onAppear {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                                    viewModel.error = nil
                                }
                            }
                    }
                    Spacer()
                }
            }
            HStack {
                Spacer()
                VStack {
                    if let error = viewModel.error {
                        ToastView(type: .error, message: error.message)
                            .padding(.top)
                            .onAppear {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                                    viewModel.error = nil
                                }
                            }
                    }
                    if let warning = viewModel.warning {
                        ToastView(type: .warning, message: warning)
                            .padding(.top)
                            .onAppear {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                                    viewModel.warning = nil
                                }
                            }
                    }
                }
                Spacer()
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
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
                .foregroundColor(Color.secondary)
                .lineLimit(3)
        }
        .frame(width: 120, alignment: .topLeading)
    }
}
