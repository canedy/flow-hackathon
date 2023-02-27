import { Link, routes } from '@redwoodjs/router'
import { MetaTags } from '@redwoodjs/web'

import { useState, useEffect, Fragment } from 'react'
import { Disclosure, Menu, Transition, RadioGroup, Tab } from '@headlessui/react'
import { CalculatorIcon, CheckBadgeIcon, UsersIcon, QuestionMarkCircleIcon, StarIcon } from '@heroicons/react/20/solid'
import { Bars3Icon, BellIcon, XMarkIcon, HeartIcon, MinusIcon, PlusIcon } from '@heroicons/react/24/outline'
import data from "../../data/quest.json"
import * as fcl from "@onflow/fcl";
import * as types from "@onflow/types";

// Cadence Scripts and Transactions
import { createCollectionTransaction } from "../../cadence/transactions/createCollection";
import { claimQuestTransaction } from "../../cadence/transactions/claimQuest.js"

const userProfile = {
  name: 'Tom Cook',
  email: 'tom@example.com',
  imageUrl:
    'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=facearea&facepad=2&w=256&h=256&q=80',
}
const navigation = [
  { name: 'Home', href: '/', current: true },
  { name: 'Collection', href: '/collection', current: false },
  // { name: 'Points', href: '#', current: false },
  // { name: 'Projects', href: '#', current: false },
  // { name: 'Calendar', href: '#', current: false },
  // { name: 'Reports', href: '#', current: false },
]
const userNavigation = [
  { name: 'Your Profile', href: '#' },
  { name: 'Settings', href: '#' },
  { name: 'Sign out', href: '#' },
]



const product = {
  name: 'North East Ohio Whiskey Tour',
  // price: '$140',
  // rating: 4,
  images: [
    {
      id: 1,
      name: 'Angled view',
      src: 'https://flow-hackathon.vercel.app/fundayz.png',
      alt: 'Angled front view with bag zipped and handles upright.',
    },
    {
      id: 2,
      name: 'Angled view',
      src: 'https://flow-hackathon.vercel.app/1.png',
      alt: 'Angled front view with bag zipped and handles upright.',
    },
    {
      id: 3,
      name: 'Angled view',
      src: 'https://flow-hackathon.vercel.app/2.png',
      alt: 'Angled front view with bag zipped and handles upright.',
    },
    {
      id: 4,
      name: 'Angled view',
      src: 'https://flow-hackathon.vercel.app/3.png',
      alt: 'Angled front view with bag zipped and handles upright.',
    },
    // More images...
  ],
  colors: [
    { name: 'Washed Black', bgColor: 'bg-gray-700', selectedColor: 'ring-gray-700' },
    { name: 'White', bgColor: 'bg-white', selectedColor: 'ring-gray-400' },
    { name: 'Washed Gray', bgColor: 'bg-gray-500', selectedColor: 'ring-gray-500' },
  ],
  description: `
    <p>Some fancy words that describe why this quest is the best of the best. Talking about the what you expect and what to see as you strive to become one with the community.</p>
  `,
  details: [
    {
      name: 'Features',
      items: [
        'The best of the best',
        'Is better that good',
        'The greatest of great',
      ],
    },
    {
      name: 'Points',
      items: [
        '2000 Points',
        '1 quest started',
        '5 actions completed',
        '5 instore visits',
        '1 special event attended',
      ],
    },    
    {
      name: 'Rewards',
      items: [
        '1 pt something good',
        '1 pt something good',
        '5 pt something good',
        '5 pt something good',
        '10 pt something good',
        '10 pt something good',

      ],
    }
    // More sections...
  ],
}


function classNames(...classes) {
  return classes.filter(Boolean).join(' ')
}

const HomePage = () => {

  const [ user, setUser ] = useState();
  const [selectedColor, setSelectedColor] = useState(product.colors[0]);

  useEffect(() => {
    // This listens to changes in the user objects
    // and updates the connected user
    fcl.currentUser().subscribe(setUser);
  }, [])

  const logIn = async () => {
    await fcl.authenticate();
    // createCollectionClick()
  };

  const logOut = () => {
    fcl.unauthenticate();
  };

  const RenderLogin = () => {
    return (
      <div>
        <a
          href="#"
          className="rounded-md border border-transparent py-1 px-2 bg-gray-700 text-gray-300 hover:bg-gray-600 hover:text-white"
          onClick={() => logIn()}>
          Connect Wallet
        </a>  
      </div>
    )
  }

  const RenderLogout = () => {
    if (user && user.addr) {
      return (
        <div>
        <a
          href="#"
          className="rounded-md border border-transparent py-1 px-2 bg-gray-700 text-gray-300 hover:bg-gray-600 hover:text-white"
          onClick={() => logOut()}>
          {user.addr}
        </a>  
      </div>
      )
    }
  }

  const RenderActionPanalConnectWallet = () => {
    return (
      <>
        {/* <div className="px-4 py-5 sm:p-6"> */}
          <h3 className="text-lg font-medium leading-6 text-gray-900">Connect Wallet</h3>
          <div className="mt-2 text-lg text-gray-500">
            <p>To get started let's login to keep track of your Craft Block Quest	&trade;</p>
          </div>
          <div className="mt-5">
            <div className="flex justify-center relative mt-1">
              <a
                href="#"
                className="rounded-md border border-transparent py-1 px-2 bg-gray-700 text-gray-300 hover:bg-gray-600 hover:text-white"
                onClick={() => logIn()}>
                Connect Wallet
              </a> 
            </div>
          </div>
        {/* </div> */}
      </>
    )
  }

  const RenderActionPanalEnterQuestCode = () => {
    return (
      <>
        <div className="px-4 py-5 sm:p-6">
          <h3 className="text-lg font-medium leading-6 text-gray-900">Enter 6-digit Quest Code</h3>
          <div className="mt-2 text-lg text-gray-500">
            <p>To get started get your your Craft Block Quest	&trade; code from particpating retailer</p>
          </div>
          <div className="mt-5">
          <div className="mt-1 flex rounded-md shadow-sm">
        <div className="relative flex flex-grow items-stretch focus-within:z-10">
          <div className="pointer-events-none absolute inset-y-0 left-0 flex items-center pl-3">
            <CalculatorIcon className="h-5 w-5 text-gray-400" aria-hidden="true" />
          </div>
          <input
            type="email"
            name="email"
            id="email"
            className="block w-full rounded-none rounded-l-md border-gray-300 pl-10 focus:border-indigo-500 focus:ring-indigo-500 sm:text-sm"
            placeholder="000000"
          />
        </div>
        <a
          href='#'
          type="button"
          className="relative -ml-px inline-flex items-center space-x-2 rounded-r-md border border-gray-300 bg-gray-50 px-4 py-2 text-sm font-medium text-gray-700 hover:bg-gray-100 focus:border-indigo-500 focus:outline-none focus:ring-1 focus:ring-indigo-500"
          onClick={() => claim()}
        >
          <CheckBadgeIcon className="h-5 w-5 text-gray-400" aria-hidden="true" />
          <span>Claim Quest</span>
        </a>
      </div>
          </div>
        </div>
      </>
    )
  }

  // const createCollectionClick = async () => {
  //   const transactionId = await fcl.send([
  //     fcl.transaction(createCollectionTransaction),
  //     fcl.args([
        
  //     ]),
  //     fcl.payer(fcl.authz),
  //     fcl.proposer(fcl.authz),
  //     fcl.authorizations([fcl.authz]),
  //     fcl.limit(9999),
  //   ]).then(fcl.decode);

  //   console.log("Transaciton id: " + transactionId)
  // }

  const claim = async() => {

    const quest = 
      {
        "image": "https://flow-hackathon.vercel.app/3.png",
        "thumbnail": "https://flow-hackathon.vercel.app/3.png",
        "name": "Cleveland Whiskey",
        "description": "Greatest tour in ohio!",
        "startDateTime": 1213.01,
        "endDateTime": 1234.01,
        "action": [
          {key: "image", value: "http://someimage.png"},
          {key: "locationName", value: "North East Ohio Tour"}
        ]
      }

 
    

    const transactionId = await fcl.mutate({
      cadence: `${claimQuestTransaction}`,
      args: (arg, t) => [
        arg(user.addr, types.Address),
        arg(quest.image, types.String),
        arg(quest.thumbnail, types.String),
        arg(quest.name, types.String),
        arg(quest.description, types.String),
        arg(quest.startDateTime, types.UFix64),
        arg(quest.endDateTime, types.UFix64),
        // arg(act.action, types.Array(types.Dictionary({key: types.String, value: types.String}))),
      ], 
      proposer: fcl.currentUser,
      payer: fcl.currentUser,
      limit: 99
    })

    console.log("Transaciton ID ", transactionId)
    
  }

  return (
    <>
      <MetaTags title="Home" description="Home page" />

      <div className="min-h-full">
        <div className="bg-gray-800 pb-32">
          <Disclosure as="nav" className="bg-gray-800">
            {({ open }) => (
              <>
                <div className="mx-auto max-w-7xl sm:px-6 lg:px-8">
                  <div className="border-b border-gray-700">
                    <div className="flex h-16 items-center justify-between px-4 sm:px-0">
                      <div className="flex items-center">
                        <div className="flex-shrink-0">
                          <img
                            className="h-8 w-8"
                            src="./favicon.png"
                            alt="Your Company"
                          />
                        </div>
                        <div className="hidden md:block">
                          <div className="ml-10 flex items-baseline space-x-4">
                            {navigation.map((item) => (
                              <a
                                key={item.name}
                                href={item.href}
                                className={classNames(
                                  item.current
                                    ? 'bg-gray-900 text-white'
                                    : 'text-gray-300 hover:bg-gray-700 hover:text-white',
                                  'px-3 py-2 rounded-md text-sm font-medium'
                                )}
                                aria-current={item.current ? 'page' : undefined}
                              >
                                {item.name}
                              </a>
                            ))}
                          </div>
                        </div>
                      </div>
                      <div className="hidden md:block">
                        <div className="ml-4 flex items-center md:ml-6">
                          {user && user.addr ? <RenderLogout />: <RenderLogin />}
                        </div>
                      </div>
                      {/* <div className="hidden md:block">
                        <div className="ml-4 flex items-center md:ml-6">
                          <button
                            type="button"
                            className="rounded-full bg-gray-800 p-1 text-gray-400 hover:text-white focus:outline-none focus:ring-2 focus:ring-white focus:ring-offset-2 focus:ring-offset-gray-800"
                          >
                            <span className="sr-only">View notifications</span>
                            <BellIcon className="h-6 w-6" aria-hidden="true" />
                          </button> */}

                          {/* Profile dropdown */}
                          {/* <Menu as="div" className="relative ml-3">
                            <div>
                              <Menu.Button className="flex max-w-xs items-center rounded-full bg-gray-800 text-sm focus:outline-none focus:ring-2 focus:ring-white focus:ring-offset-2 focus:ring-offset-gray-800">
                                <span className="sr-only">Open user menu</span>
                                <img className="h-8 w-8 rounded-full" src={user.imageUrl} alt="" />
                              </Menu.Button>
                            </div>
                            <Transition
                              as={Fragment}
                              enter="transition ease-out duration-100"
                              enterFrom="transform opacity-0 scale-95"
                              enterTo="transform opacity-100 scale-100"
                              leave="transition ease-in duration-75"
                              leaveFrom="transform opacity-100 scale-100"
                              leaveTo="transform opacity-0 scale-95"
                            >
                              <Menu.Items className="absolute right-0 z-10 mt-2 w-48 origin-top-right rounded-md bg-white py-1 shadow-lg ring-1 ring-black ring-opacity-5 focus:outline-none">
                                {userNavigation.map((item) => (
                                  <Menu.Item key={item.name}>
                                    {({ active }) => (
                                      <a
                                        href={item.href}
                                        className={classNames(
                                          active ? 'bg-gray-100' : '',
                                          'block px-4 py-2 text-sm text-gray-700'
                                        )}
                                      >
                                        {item.name}
                                      </a>
                                    )}
                                  </Menu.Item>
                                ))}
                              </Menu.Items>
                            </Transition>
                          </Menu>
                        </div>
                      </div> */}
                      <div className="-mr-2 flex md:hidden">
                        {/* Mobile menu button */}
                        <Disclosure.Button className="inline-flex items-center justify-center rounded-md bg-gray-800 p-2 text-gray-400 hover:bg-gray-700 hover:text-white focus:outline-none focus:ring-2 focus:ring-white focus:ring-offset-2 focus:ring-offset-gray-800">
                          <span className="sr-only">Open main menu</span>
                          {open ? (
                            <XMarkIcon className="block h-6 w-6" aria-hidden="true" />
                          ) : (
                            <Bars3Icon className="block h-6 w-6" aria-hidden="true" />
                          )}
                        </Disclosure.Button>
                      </div>
                    </div>
                  </div>
                </div>

                <Disclosure.Panel className="border-b border-gray-700 md:hidden">
                  <div className="space-y-1 px-2 py-3 sm:px-3">
                    {navigation.map((item) => (
                      <Disclosure.Button
                        key={item.name}
                        as="a"
                        href={item.href}
                        className={classNames(
                          item.current ? 'bg-gray-900 text-white' : 'text-gray-300 hover:bg-gray-700 hover:text-white',
                          'block px-3 py-2 rounded-md text-base font-medium'
                        )}
                        aria-current={item.current ? 'page' : undefined}
                      >
                        {item.name}
                      </Disclosure.Button>
                    ))}
                  </div>
                  <div className="border-t border-gray-700 pt-4 pb-3">
                    <div className="flex items-center px-5">
                      <div className="flex-shrink-0">
                        <img className="h-10 w-10 rounded-full" src={userProfile.imageUrl} alt="" />
                      </div>
                      <div className="ml-3">
                        <div className="text-base font-medium leading-none text-white">{userProfile.name}</div>
                        <div className="text-sm font-medium leading-none text-gray-400">{userProfile.email}</div>
                      </div>
                      <button
                        type="button"
                        className="ml-auto flex-shrink-0 rounded-full bg-gray-800 p-1 text-gray-400 hover:text-white focus:outline-none focus:ring-2 focus:ring-white focus:ring-offset-2 focus:ring-offset-gray-800"
                      >
                        <span className="sr-only">View notifications</span>
                        <BellIcon className="h-6 w-6" aria-hidden="true" />
                      </button>
                    </div>
                    <div className="mt-3 space-y-1 px-2">
                      {userNavigation.map((item) => (
                        <Disclosure.Button
                          key={item.name}
                          as="a"
                          href={item.href}
                          className="block rounded-md px-3 py-2 text-base font-medium text-gray-400 hover:bg-gray-700 hover:text-white"
                        >
                          {item.name}
                        </Disclosure.Button>
                      ))}
                    </div>
                  </div>
                </Disclosure.Panel>
              </>
            )}
          </Disclosure>
          <header className="py-10">
            <div className="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8">
              <h1 className="text-3xl font-bold tracking-tight text-white">Craft Block Quest &trade;</h1>
            </div>
          </header>
        </div>

        <main className="-mt-32">
          <div className="mx-auto max-w-7xl px-4 pb-12 sm:px-6 lg:px-8">
            {/* Replace with your content */}
            <div className="rounded-lg bg-white px-5 py-6 shadow sm:px-6">
              <h1 className="text-3xl text-center font-bold text-gray-600">GET ON THE TRAIL! MEET NEW FRIENDS! ENJOY LIBATIONS! EXPERIENCE FUN!</h1>
              
              <div className='px-60'>
                <ol className='mt-6'>
                  <li className='pb-5'><a className="font-semibold underline underline-offset-4 text-gray-900">EMBARK</a> on a craft beverage journey and discover new favorites with Craft Block Trails</li>
                  <li className='pb-5'><a className="font-semibold underline underline-offset-4 text-gray-900">JOIN</a> a community of like-minded craft beverage enthusiasts with Craft Block Communities</li>
                  <li className='pb-5'><a className="font-semibold underline underline-offset-4 text-gray-900">EXPERIENCE</a> special privileges and VIP access with Craft Block Pass</li>
                  <li className=''><a className="font-semibold underline underline-offset-4 text-gray-900">UNLOCK</a> a new level of craft beverage experience with Craft Block Games.</li>
                  {/* <li className='pb-2'>All benefits are <a className="font-semibold text-gray-900">SHARED</a> and <a className="font-semibold text-gray-900">TRADABLE</a> across retail companies</li> */}
                </ol>
              </div>
              <p className='mt-6 text-center'>All benefits are <a className="font-semibold text-gray-900">SHARED</a> and <a className="font-semibold text-gray-900">TRADABLE</a> across retail companies</p>


              <p className="text-center py-12">TODO - Insert Video of what this app can do</p>
              
              <div className=" py-6 px-6 text-center bg-gray-50 sm:rounded-lg">  
                {user && user.addr ? <RenderActionPanalEnterQuestCode />: <RenderActionPanalConnectWallet />}
              </div>

             
            </div>
            {/* /End replace */}
          </div>
        </main>
      </div>
    </>
  )
}

export default HomePage
