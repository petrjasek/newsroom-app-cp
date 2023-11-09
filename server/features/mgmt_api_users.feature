Feature: Management API - Users
    Scenario: Create a user
        Given empty "users"
        And "products"
        """
        [
            {"name": "test", "query": "test"}
        ]
        """
        When we post to "/users"
        """
        {
            "first_name": "John",
            "last_name": "Cena",
            "email": "johncena@wwe.com"
        }
        """
        Then we get error 400
        When we post to "/companies"
        """
        [{"name": "zzz company"}]
        """
        Then we get response code 201
        When we post to "/users"
        """
        {
            "first_name": "John",
            "last_name": "Cena",
            "email": "johncena@wwe.com",
            "company": "#companies._id#",
            "user_type": "company_admin",
            "sections": {
                "wire": true
            },
            "products": [
                {"section": "wire", "_id": "#products._id#"}
            ]
        }
        """
        Then we get response code 201
        When we post to "/users"
        """
        {
            "first_name": "John",
            "last_name": "Cena",
            "email": "johncena1@wwe.com",
            "user_type": "administrator"
        }
        """
        Then we get response code 201
        When we get "/users"
        Then we get existing resource
        """
        {
        "_items" :
            [
                {
                    "first_name": "John",
                    "last_name": "Cena",
                    "email": "johncena@wwe.com",
                    "company": "#companies._id#",
                    "user_type": "company_admin",
                    "sections": {
                        "wire": true
                    },
                    "products": [
                        {"section": "wire", "_id": "__objectid__"}
                    ]
                },
                {
                    "first_name": "John",
                    "last_name": "Cena",
                    "email": "johncena1@wwe.com",
                    "user_type": "administrator"
                }
            ]
        }
        """

    Scenario: Update a user
        Given empty "users"
        When we post to "/users"
        """
        {
            "first_name": "John",
            "last_name": "Cena",
            "email": "johncena@wwe.com",
            "user_type": "administrator"
        }
        """
        When we patch latest
        """
        {"last_name": "wick"}
        """
        Then we get updated response
        """
        {"last_name": "wick"}
        """

    Scenario: Delete a user
        Given empty "users"
        When we post to "/users"
        """
        {
            "first_name": "John",
            "last_name": "Cena",
            "email": "johncena@wwe.com",
            "user_type": "administrator"
        }
        """
        When we delete latest
        Then we get ok response

    Scenario: Validate product type
        Scenario: Create a user
        Given empty "users"
        And "products"
        """
        [
            {"name": "test", "query": "test", "product_type": "agenda"}
        ]
        """
        And "companies"
        """
        [{"name": "zzz company"}]
        """

        When we post to "/users"
        """
        {
            "first_name": "John",
            "last_name": "Cena",
            "email": "johncena@wwe.com",
            "company": "#companies._id#",
            "sections": {
                "agenda": true
            },
            "products": [
                {"_id": "#products._id#", "section": "wire"}
            ]
        }
        """
        Then we get error 400
        """
        {"code": 400, "message": "invalid product type for product #products._id#, should be agenda"}
        """

        When we post to "/users"
        """
        {
            "first_name": "John",
            "last_name": "Cena",
            "email": "johncena@wwe.com",
            "company": "#companies._id#",
            "sections": {
                "agenda": true
            },
            "products": [
                {"section": "agenda", "_id": "#products._id#"}
            ]
        }
        """
        Then we get response code 201

        When we patch "/users/#users._id#"
        """
        {
            "products": [
                {"section": "wire", "_id": "#products._id#"}
            ]
        }
        """
        Then we get error 400

        When we patch "/users/#users._id#"
        """
        {
            "products": [
                {"section": "agenda", "_id": "#products._id#"}
            ]
        }
        """
        Then we get response code 200
