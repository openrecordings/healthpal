desc 'Create two orgs and users for each org for development'
task create_dummy_users: :environment do
  ['org1', 'org2'].each do |org_name|
    org = Org.create(name: org_name)
    user = User.new(
      email: "#{org_name}-admin-user@example.com",
      role: 'admin',
      active: true,
      first_name: 'Adminuser',
      last_name: org_name,
      onboarded: true,
      org: org
    )
    user.password = 'not-secure'
    user.save!
    user = User.new(
      email: "#{org_name}-regular-user@example.com",
      role: 'user',
      active: true,
      first_name: 'Reguser',
      last_name: org_name,
      onboarded: true,
      org: org
    )
    user.password = 'not-secure'
    user.save!
  end
end