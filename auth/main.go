package main

import (
	"github.com/gin-gonic/gin"
	"github.com/jinzhu/gorm"
	_ "github.com/jinzhu/gorm/dialects/mysql"
    "time"
    "fmt"
    "os"
)

type User struct {
	gorm.Model
	Id               int
	Username         string
	FirstName        string
	LastName         string
	Email            string
	Password         string
	PasswordNewHash  string
	IsActive         bool
	LastLogin        time.Time
	DateJoined       time.Time
	AutoHash         string
	RegistrationCode string
	PasswordCode     string
	IsEditor         bool
	IsDeveloper      bool
	IsAdmin          bool
	isPremium        bool
	SkypeHandle      string
	GoogleId         string
	GoogleSessionId  string
}

func main() {
	db, err := gorm.Open("mysql", fmt.Sprintf("%s:%s@%s/%s?charset=utf8&parseTime=True&loc=UTC",
		os.Getenv("MYSQL_USER"),
		os.Getenv("MYSQL_PASS"),
		os.Getenv("MYSQL_HOST"),
		os.Getenv("MYSQL_DB"),
	))
	if err != nil {
		panic("failed to connect database")
	}
	defer db.Close()

	r := gin.Default()
	r.GET("/ping", func(c *gin.Context) {
		c.JSON(200, gin.H{
			"message": "pong",
		})
	})
	r.POST("/authenticate", func(c *gin.Context) {
		/* if user = Repo.get_by(Model.User, username: username) do
		   cond do
		     user.password_new_hash && Comeonin.Bcrypt.checkpw(password, user.password_new_hash) -> user
		     (s = user.password |> String.split("$")) && Enum.count(s) == 3 ->
		       # validation for old passwords (SHA1)
		       [_algorithm, salt, pass] = s
		       calc_pass = :crypto.hash(:sha, "#{salt}#{password}") |> Base.encode16 |> String.downcase

		       case String.equivalent?(pass, calc_pass) do
		         true  -> user
		         false -> nil
		       end
		     true -> nil
           end*/
           


           

	})
	r.Run()
}
