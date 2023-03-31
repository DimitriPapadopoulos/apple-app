import AuthClient
import ComposableArchitecture
import Models
import SwiftUI

public struct ConnectView: View {
    public init(store: StoreOf<Connect>) {
        self.store = store
    }
    
    let store: StoreOf<Connect>
    
#if targetEnvironment(macCatalyst)
        // FIXME: EnvironmentObject broken on macCatalyst?!
    let theme = Theme(
        searchFont: .custom("OpenSans-Regular", size: 20, relativeTo: .body),
        errorFont: .custom("OpenSans-Regular", size: 16, relativeTo: .body),
        institutionNameFont: .custom("OpenSans-Bold", size: 16, relativeTo: .body),
        institutionCountryFont: .custom("OpenSans-Regular", size: 11, relativeTo: .footnote),
        profilesHeaderFont: .custom("OpenSans-SemiBold", size: 12, relativeTo: .body),
        profileNameFont: .custom("OpenSans-Regular", size: 16, relativeTo: .body),
        connectButtonFont: .custom("OpenSans-Bold", size: 20, relativeTo: .body),
        connectedFont: .custom("OpenSans-Bold", size: 14, relativeTo: .body),
        infoHeaderFont: .custom("OpenSans-Bold", size: 14, relativeTo: .body),
        infoDetailFont: .custom("OpenSans-Regular", size: 14, relativeTo: .body))
#else
    @EnvironmentObject var theme: Theme
#endif
    
    // TODO: Define ViewState
    
    public var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            VStack(alignment: .leading) {
                HStack(alignment: .firstTextBaseline) {
                    VStack(alignment: .leading) {
                        Text(viewStore.institution.name)
                            .font(theme.institutionNameFont)
                        Text(viewStore.institution.country)
                            .font(theme.institutionCountryFont)
                    }
                    Spacer()
                    Button(action: {
                        viewStore.send(.dismissTapped)
                    }, label: {
                        Image(systemName: "xmark")
                    })
                    .buttonStyle(.plain)
                }
                .padding(20)
                
                if viewStore.isConnected == false {
                    List {
                        Section {
                            let selectedProfile = viewStore.selectedProfile
                            ForEach(viewStore.institution.profiles) { profile in
                                Button {
                                    viewStore.send(.select(profile.id))
                                } label: {
                                    ProfileRowView(profile: profile, isSelected: selectedProfile == profile)
                                }
                                .listRowSeparatorTint(Color("ListSeparator"))
                                .listRowBackground(Color("Background"))
                            }
                        } header: {
                            Text("Profiles", bundle: .module)
                                .font(theme.profilesHeaderFont)
                        }
                    }
                    .listStyle(.plain)
                    .disabled(viewStore.canSelectProfile == false)
                }
               
                if let providerInfo = viewStore.providerInfo {
                    Spacer()
                    HelpdeskView(providerInfo: providerInfo)
                        .padding(20)
                }
                
                HStack {
                    Spacer()
                    VStack(alignment: .center) {
                        if viewStore.isConnected {
                            Label(title: {
                                Text("Connected", bundle: .module)
                            }, icon: {
                                Image(systemName: "checkmark")
                            })
                                .font(theme.connectedFont)
                        } else {
                            Button {
                                viewStore.send(.connect)
                            } label: {
                                Text("CONNECT", bundle: .module)
                                    .multilineTextAlignment(.center)
                            }
                            .disabled(viewStore.isLoading)
                            .buttonStyle(ConnectButtonStyle())
                        }
                    }
                    Spacer()
                }
            }
            .onAppear {
                viewStore.send(.onAppear)
            }
            .background {
                BackgroundView(showLogo: false)
            }
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
            .alert(
                store: store.scope(state: \.$destination, action: Connect.Action.destination),
                state: /Connect.Destination.State.termsAlert,
                action: Connect.Destination.Action.termsAlert
            )
            .alert(
                store: store.scope(state: \.$destination, action: Connect.Action.destination),
                state: /Connect.Destination.State.alert,
                action: Connect.Destination.Action.alert
            )
            .alert("Login Required",
                   isPresented: viewStore.binding(
                    get: \.promptForCredentials,
                    send: Connect.Action.dismissPromptForCredentials),
                   actions: {
                TextField(viewStore.usernamePrompt, text: viewStore.binding(
                    get: \.username,
                    send: Connect.Action.updateUsername))
                .textContentType(.username)
                SecureField("Password", text: viewStore.binding(
                    get: \.password,
                    send: Connect.Action.updatePassword))
                .textContentType(.password)
                Button("Cancel", role: .cancel, action: {
                    viewStore.send(.dismissPromptForCredentials)
                })
                Button("Log In", action: {
                    viewStore.send(.logInButtonTapped)
                })
            }, message: {
                Text("Please enter your username and password.")
            })
        }
    }
}

struct ConnectView_Previews: PreviewProvider {
    static var previews: some View {
        ConnectView(store: .init(
            initialState: .init(
                institution: .init(
                    id: "1",
                    name: "My Institution",
                    country: "NL",
                    cat_idp: 1,
                    profiles: [
                        .init(
                            id: "2",
                            name: "My Profile",
                            default: true,
                            eapconfig_endpoint: nil,
                            oauth: false,
                            authorization_endpoint: nil,
                            token_endpoint: nil),
                        .init(
                            id: "3",
                            name: "Other Profile",
                            default: false,
                            eapconfig_endpoint: nil,
                            oauth: false,
                            authorization_endpoint: nil,
                            token_endpoint: nil)
                    ],
                    geo: [.init(lat: 0, lon: 0)])),
            reducer: Connect()))
        .environmentObject(Theme.demo)
    }
}
