Feature: Management API

    Scenario: API is up and running
        When we get "/"
        Then we get OK response

    Scenario: Create a company
        Given empty "companies"
        When we post to "/companies"
        """
        {
            "name": "zzz company",
            "contact_name": "zzz company",
            "country": "Iceland",
            "contact_email": "contact@zzz.com",
            "phone": "99999999"
        }
        """
        Then we get response code 201
        When we get "/companies"
        Then we get existing resource
        """
        {
        "_items" :
            [
                {
                    "name": "zzz company",
                    "contact_name": "zzz company",
                    "country": "Iceland",
                    "contact_email": "contact@zzz.com",
                    "phone": "99999999"
                }
            ]
        }
        """


    Scenario: Delete a company
       Given empty "companies"
        When we post to "/companies"
        """
        [{"name": "zzz company"}]
        """
        When we delete latest
        Then we get response code 204


    Scenario: Update a compnay
        Given empty "companies"
        When we post to "/companies"
        """
        [{"name": "zzz company"}]
        """
        When we patch latest
        """
        {"name": "xyz company"}
        """
        Then we get updated response
        """
        {"name": "xyz company"}
        """


    Scenario: Create a user
        Given empty "users"
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
            "company": "#companies._id#"
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
                    "company": "#companies._id#"
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


    Scenario: Get company products
        Given empty "companies"
        When we post to "/companies"
        """
        [{"name": "zzz company"}]
        """
        Then we get response code 201

        Given empty "products"
        When we post to "/products"
        """
        [{
            "name": "A fishy Product",
            "description": "a product for those interested in fish",
            "query": "fish",
            "product_type": "news_api"
        }]
        """
        Then we get response code 201

        When we get "/products"
        Then we get existing resource
        """
        {"_items": [
            {"name": "A fishy Product"}
        ]}
        """
        When we patch "/products/#products._id#"
        """
        {"description": "new description"}
        """
        Then we get response code 200

        When we post to "companies/#companies._id#/products"
        """
        [
            {
                "product": "#products._id#",
                "link": true
            }
        ]
        """
        Then we get response code 201

        When we get "companies/#companies._id#/products"
        Then we get existing resource
        """
        {"_items": [
            {
                "name": "A fishy Product",
                "description": "new description",
                "query": "fish",
                "product_type": "news_api"
            }
        ]}
        """
        When we post to "companies/#companies._id#/products"
        """
        [
            {
                "product": "#products._id#",
                "link": false
            }
        ]
        """
        Then we get response code 201
        When we get "companies/#companies._id#/products"
        Then we get existing resource
        """
        {"_items": []}
        """

        When we delete "/products/#products._id#"
        Then we get response code 204


    Scenario: test auth without token
        Given empty auth token
        When we get "/"
        Then we get response code 401

        When we get "/users"
        Then we get response code 401


    Scenario: Create a navigation
        Given empty "navigations"
        When we post to "/navigations"
        """
        {
            "name": "navigation1",
            "description": "navigation1",
            "order": 1
        }
        """
        Then we get response code 201
        When we get "/navigations"
        Then we get existing resource
        """
        {
        "_items" :
            [
                {
                    "name": "navigation1",
                    "description": "navigation1",
                    "order": 1
                }
            ]
        }
        """


    Scenario: Delete a navigation
       Given empty "navigations"
        When we post to "/navigations"
        """
        [{
            "name": "navigation1",
            "description": "navigation1",
            "order": 1
        }]
        """
        When we delete latest
        Then we get response code 204


    Scenario: Update a navigation
        Given empty "navigations"
        When we post to "/navigations"
        """
        [{"name": "navigation1"}]
        """
        When we patch latest
        """
        {"name": "navigation2"}
        """
        Then we get updated response
        """
        {"name": "navigation2"}
        """


    Scenario: Create a topic
        Given empty "companies"
        When we post to "/companies"
        """
        [{"name": "zzz company"}]
        """
        Then we get response code 201
        Given empty "topics"
        When we post to "/topics"
        """
        {
            "label": "topic1",
            "company": "#companies._id#",
            "topic_type": "wire",
            "query": "topic1",
            "is_global": true
        }
        """
        Then we get response code 201
        When we get "/topics"
        Then we get existing resource
        """
        {
        "_items" :
            [
                {
                    "label": "topic1",
                    "company": "#companies._id#",
                    "topic_type": "wire",
                    "query": "topic1",
                    "is_global": true
                }
            ]
        }
        """


    Scenario: Delete a topic
        Given empty "companies"
        When we post to "/companies"
        """
        [{"name": "zzz company"}]
        """
        Then we get response code 201
        Given empty "topics"
        When we post to "/topics"
        """
        [{
            "label": "topic1",
            "company": "#companies._id#",
            "topic_type": "wire",
            "query": "topic1",
            "is_global": true
        }]
        """
        When we delete latest
        Then we get response code 204


    Scenario: Update a topic
        Given empty "companies"
        When we post to "/companies"
        """
        [{"name": "zzz company"}]
        """
        Then we get response code 201
        Given empty "topics"
        When we post to "/topics"
        """
        [{
            "label": "topic1",
            "company": "#companies._id#",
            "topic_type": "wire",
            "query": "topic1",
            "is_global": true
        }]
        """
        When we patch latest
        """
        {"label": "topic2"}
        """
        Then we get updated response
        """
        {"label": "topic2"}
        """
