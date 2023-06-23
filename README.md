# Faker
Easy way to falcificate some project by your custom configuration.

<p align="center">
    <img src="https://img.shields.io/badge/Swift-5.2-orange.svg" />
    <a href="https://github.com/yonaskolb/Mint">
          <img src="https://img.shields.io/badge/mint-compatible-brightgreen.svg?style=flat" alt="Mint" />
    </a>
</p>

## Using

1. Setup your .yml in the following format:

```yml
 replace:
   - files: <files mask or path>
     from: <original string>
     to: <target string>
 remove:
   - files: <files mask or path>
     string: <original string>
 xcode:
   - project: <xcproj file name>
     drop:
       targets:
         except: <bool, true - except list, false - include only list>
         list: <list of targets>
       capabilities:
         except: <bool, true - except list, false - include only list>
         list: <list of targets>
       build_phases: <list of build phases>
```
           
2. Run `face --y <path to .yml> --proj <path to project>`  

## Installing
- From source: `make install`


## Authors

* Nikolay Tyunin, n.n.tyunin@gmail.com

## About

<img src="https://github.com/rosberry/Foundation/blob/master/Assets/full_logo.png?raw=true" height="100" />

This project is owned and maintained by [Nikolai Tiunin](https://vk.com/nekodosi). We build mobile apps for users worldwide 🌏.

Check out our [open source projects](https://github.com/ntunin).

## License

The project is available under the MIT license. See the LICENSE file for more info.
