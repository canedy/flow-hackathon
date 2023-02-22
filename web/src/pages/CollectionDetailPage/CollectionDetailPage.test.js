import { render } from '@redwoodjs/testing/web'

import CollectionDetailPage from './CollectionDetailPage'

//   Improve this test with help from the Redwood Testing Doc:
//   https://redwoodjs.com/docs/testing#testing-pages-layouts

describe('CollectionDetailPage', () => {
  it('renders successfully', () => {
    expect(() => {
      render(<CollectionDetailPage />)
    }).not.toThrow()
  })
})
