package main

import (
	"github.com/gin-gonic/gin"
	"github.com/jinzhu/gorm"
	_ "github.com/jinzhu/gorm/dialects/mysql"
	"encoding/json"
    "time"
    "fmt"
    "os"
)

type User struct {
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
	connection := fmt.Sprintf("%s:%s@tcp(%s:3306)/%s?charset=utf8&parseTime=True&loc=UTC",
		os.Getenv("MYSQL_USER"),
		os.Getenv("MYSQL_PASS"),
		os.Getenv("MYSQL_HOST"),
		os.Getenv("MYSQL_DB"),
	)

	db, err := gorm.Open("mysql", connection)
	if err != nil {
		fmt.Println(err)
		panic("failed to connect database")
	}
	defer db.Close()

	r := gin.Default()
	r.GET("/user/:id", func(c *gin.Context) {
		fmt.Println(c.Param("id"))
		fmt.Println("HEADER", c.Request.Header.Get("x-user"))

		var user User
		db.Where("id = ?", c.Param("id")).First(&user)

		c.JSON(200, user)
	})
	r.GET("/ping", func(c *gin.Context) {
		c.JSON(200, gin.H{
			"message": "pong",
		})
	})
	r.Any("/extauth/*path", func(c *gin.Context) {
		cookie, _ := c.Request.Cookie("auto_hash")

		var user User
		if cookie != nil {
			db.Where("auto_hash = ?", cookie.Value).First(&user)
			b, _ := json.Marshal(user)
			c.Writer.Header().Set("x-user", string(b))
		}

		c.JSON(200, gin.H{})
	})
	r.Run(":8080")
}
