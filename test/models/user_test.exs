defmodule KirruptTv.UserTest do
  use KirruptTv.ModelCase

  alias KirruptTv.User
  alias Model.User

  @valid_attrs %{
    email: "jdoe@example.com",
    password: "testpass",
    username: "jdoe",
    first_name: "john",
    last_name: "doe"
  }

  # @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = User.registration_changeset(%User{}, @valid_attrs)
    assert changeset.valid?
  end

  test "ensure passwords are correctly encrypted" do
    changeset = User.registration_changeset(%User{}, @valid_attrs)

    sha1_pass = get_field(changeset, :password)
    bcrypt_pass = get_field(changeset, :password_new_hash)

    assert String.slice(sha1_pass, 0..4) == "sha1$"
    assert String.slice(bcrypt_pass, 0..6) == "$2b$12$"

    assert validate_sha1(sha1_pass, "testpass")
    assert validate_bcrypt(bcrypt_pass, "testpass")
  end

  test "should authenticate" do
    changeset = User.registration_changeset(%User{}, @valid_attrs)
    assert changeset.valid?
    Model.User.register_user(changeset)

    # try with new password format
    assert User.authenticate("jdoe", "testpass")

    user = Repo.get_by(Model.User, username: "jdoe")

    # old password
    set_hashes_and_authenticate(user.password, nil)

    # pre-generated old password
    set_hashes_and_authenticate("sha1$dbab5b324e$d12c3e9c16ccd83311ceda4041f35492aa866a60", nil)

    # pre-generated new password
    set_hashes_and_authenticate(
      "fake",
      "$2b$12$0N4EOG/aVjfVgOFC218yUOR6jtcHJacEExEJe4DPWyghS87ipZFdy"
    )
  end

  defp set_hashes_and_authenticate(old_hash, new_hash) do
    Repo.get_by(Model.User, username: "jdoe")
    |> Ecto.Changeset.cast(%{password: old_hash, password_new_hash: new_hash}, [
      :password,
      :password_new_hash
    ])
    |> Repo.update!()

    assert Repo.get_by(Model.User, username: "jdoe").password == old_hash
    assert Repo.get_by(Model.User, username: "jdoe").password_new_hash == new_hash

    assert User.authenticate("jdoe", "testpass")
  end

  # intentionally duplicated, to ensure that changes in `user.ex` don't break existing passwords
  defp validate_sha1(hashed, actual) do
    s = hashed |> String.split("$")
    assert Enum.count(s) == 3

    [_algorithm, salt, pass] = s
    calculated = :crypto.hash(:sha, "#{salt}#{actual}") |> Base.encode16() |> String.downcase()

    String.equivalent?(pass, calculated)
  end

  # intentionally duplicated, to ensure that changes in `user.ex` don't break existing passwords
  defp validate_bcrypt(hashed, actual) do
    Bcrypt.verify_pass(actual, hashed)
  end

  """
  test "changeset with invalid attributes" do
    changeset = User.changeset(%User{}, @invalid_attrs)
    refute changeset.valid?
  end
  """
end
